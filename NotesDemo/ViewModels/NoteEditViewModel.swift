//
//  NoteEditViewModel.swift
//  notesdemo
//
//  Created by Nitesh Tak on 28/12/20.
//

import Foundation

enum NoteType {
    case new, update
    
    var title: String {
        switch self {
        case .new:
            return "New Note"
        default:
            return "Update Note"
        }
    }
}


class NoteEditViewModel {
    
    var api: NotesAPIProtocol
    var note: Note = Note(id: UUID().uuidString, title: "New Note", description: "")
    
    var type: NoteType = .new
    
    var didAddNote: ((Bool) -> ())? = nil
    var didUpdateNote: ((Bool) -> ())? = nil
    
    init(apiService: NotesAPIProtocol = NoteService()) {
        self.api = apiService
    }
    
    func addNewNote() {
        api.addNewNote(title: self.note.title, description: self.note.description) { (isSuccess) in
            self.didAddNote?(isSuccess)
        }
    }
    
    func saveNote(index: Int) {
        api.updateNote(note: self.note, index: index) { isSuccess in
            self.didUpdateNote?(true)
        }
    }
    
}
