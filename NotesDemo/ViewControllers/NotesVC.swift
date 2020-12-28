//
//  NotesVC.swift
//  notesdemo
//
//  Created by Nitesh Tak on 27/12/20.
//

import UIKit

class NotesVC: UITableViewController {
    
    var type: NoteType = .new
    
    var selectedIndex: Int!
    
    lazy var viewModel: NotesViewModel = {
        return NotesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init view
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        fetchAllNotes()
    }
    
    func initView() {
        self.title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.tableView.tableFooterView = UIView()
    }
    
    func fetchAllNotes() {
        viewModel.initFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditNote", let vc = segue.destination as? AddNoteVC, let note = viewModel.selectedNote {
            vc.type = self.type
            vc.noteId = self.type == .update ? note.id : nil
            vc.index = self.selectedIndex
            vc.note = self.viewModel.selectedNote
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Actions
    @objc func addNote() {
        type = .new
        self.performSegue(withIdentifier: "ShowEditNote", sender: self)
    }
    
    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension NotesVC {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteItemCell", for: indexPath) as? NoteItemCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.noteListCellViewModel = cellVM
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.numberOfCells == 0 {
            viewModel.isAllowSegue = false
            tableView.setEmptyMessage("You do not have any notes yet 😔")
        } else {
            tableView.restore()
        }
        
        return viewModel.numberOfCells
    }
    
    // didSelectRowAtIndexPath - change background color
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteItemCell", for: indexPath) as? NoteItemCell {
            cell.selectionStyle = .default
        }
        type = .update
        selectedIndex = indexPath.row
        self.viewModel.userPressed(at: indexPath)
        self.performSegue(withIdentifier: "ShowEditNote", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteItemCell", for: indexPath) as? NoteItemCell {
            cell.selectionStyle = .default
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteNote(index: indexPath.row)
        }
    }
    
}


