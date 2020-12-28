//
//  NoteService.swift
//  notesdemo
//
//  Created by Nitesh Tak on 28/12/20.
//

import Foundation

class NoteService: NotesAPIProtocol {
    
    func deleteNote(index: Int, complete: @escaping (Bool) -> ()) {
        Storage.shared.deleteExistingNote(index: index)
        complete(true)
    }
    
    func fetchNotes(complete: @escaping (Bool, [Note]) -> ()) {
        complete(true, Storage.shared.getAllNotes())
    }
    
    func addNewNote(title: String, description: String, complete: @escaping (Bool) -> ()) {
        let note = Note(id: UUID().uuidString, title: title, description: description)
        Storage.shared.addNewNote(note: note)
        complete(true)
    }
    
    func updateNote(note: Note, index: Int, complete: @escaping (Bool) -> ()) {
        Storage.shared.saveExistingNote(note: note, index: index)
        complete(true)
    }
    
}
