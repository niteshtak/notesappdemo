//
//  AddNoteVC.swift
//  notesdemo
//
//  Created by Nitesh Tak on 27/12/20.
//

import UIKit

class AddNoteVC: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var type: NoteType = .new
    
    var noteId: String?
    var index: Int!
    var note: Note?
    
    lazy var viewModel: NoteEditViewModel = {
        return NoteEditViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = type.title
        if let note = self.note {
            self.viewModel.note = note
        }
        setTextViewDesign()
        titleTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func isFormValidated() -> Bool {
        return descriptionTextView.text != nil && !descriptionTextView.text.isEmpty
    }
    
    @objc func textFieldDidChange() {
        self.viewModel.note.title = titleTextField.text ?? "New Note"
    }
    
    func setViewData() {
        switch type {
        case .update: // Update existing note
            
            titleTextField.text = viewModel.note.title
            descriptionTextView.text = viewModel.note.description
            actionButton.setTitle("Save", for: .normal)
            
            self.actionButton?.addTargetClosure { [weak self] button in
                if let self = self, self.isFormValidated(), let noteId = self.noteId {
                    self.viewModel.note.id = noteId
                    self.viewModel.saveNote(index: self.index)
                }
            }
            
            self.viewModel.didUpdateNote = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            
        case .new:  // Add a new note
            actionButton.setTitle("Add Note", for: .normal)
            self.actionButton?.addTargetClosure { [weak self] button in
                if let self = self, self.isFormValidated(), let title = self.titleTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.viewModel.note = Note(id: UUID().uuidString, title: title, description: self.descriptionTextView.text)
                    self.viewModel.addNewNote()
                }
            }
            
            self.viewModel.didAddNote = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddNoteVC {
    
    func setTextViewDesign() {
        let borderColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = borderColor.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        descriptionTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        viewModel.note.description = descriptionTextView.text
        descriptionTextView.resignFirstResponder()
    }
}

extension AddNoteVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    
}
