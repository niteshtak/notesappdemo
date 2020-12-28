//
//  NotesViewModel.swift
//  notesdemo
//
//  Created by Nitesh Tak on 27/12/20.
//

import Foundation

class NotesViewModel {
    
    var api: NotesAPIProtocol
    
    var fetchHandler:(([Note]) -> ())?
    var notesList: [Note] = []
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue = false
    
    var selectedNote: Note?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    
    private var cellViewModels: [NotesListCellViewModel] = [NotesListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    init(apiService: NotesAPIProtocol = NoteService()) {
        self.api = apiService
    }
    
    func initFetch() {
        api.fetchNotes { [weak self] (isSuccess, notes) in
            self?.processFetchedNotes(notes: notes)
        }
    }
    
    func deleteNote(index: Int) {
        api.deleteNote(index: index) { [weak self] isSuccess in
            if isSuccess,  var vms = self?.cellViewModels {
                vms.remove(at: index)
                self?.cellViewModels = vms
            }
        }
    }
    
    func createCellViewModel(note: Note) -> NotesListCellViewModel {
        return NotesListCellViewModel(titleText: note.title,
                                       descText: note.description)
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> NotesListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func processFetchedNotes(notes: [Note]) {
        self.notesList = notes // Cache
        var vms = [NotesListCellViewModel]()
        for note in notes {
            vms.append(createCellViewModel(note: note) )
        }
        self.cellViewModels = vms
    }
    
}

extension NotesViewModel {
    func userPressed(at indexPath: IndexPath) {
        isAllowSegue = true
        let note = self.notesList[indexPath.row]
        self.selectedNote = note
    }
}

struct NotesListCellViewModel {
    let titleText: String
    let descText: String
}
