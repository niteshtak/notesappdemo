//
//  MockService.swift
//  notesdemo
//
//  Created by Nitesh Tak on 28/12/20.
//

import Foundation

class MockService: NotesAPIProtocol {
    
    var isFetchNotesCalled = false
    var isAddNoteCalled = false
    var isUpdateNoteCalled = false
    var isDeleteNoteCalled = false
    
    func fetchNotes(complete: @escaping (Bool, [Note]) -> ()) {
        isFetchNotesCalled = true
    }
    
    func addNewNote(title: String, description: String, complete: @escaping (Bool) -> ()) {
        isAddNoteCalled = true
    }
    
    func updateNote(note: Note, index: Int, complete: @escaping (Bool) -> ()) {
        isUpdateNoteCalled = true
    }
    
    func deleteNote(index: Int, complete: @escaping (Bool) -> ()) {
        isDeleteNoteCalled = true
    }
    
}
