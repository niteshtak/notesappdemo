//
//  NotesAPIProtocol.swift
//  notesdemo
//
//  Created by Nitesh Tak on 28/12/20.
//

import Foundation


protocol NotesAPIProtocol {
    
    func fetchNotes(complete: @escaping (Bool, [Note]) -> ())
    
    func addNewNote(title: String, description: String, complete: @escaping (Bool) -> ())
    
    func updateNote(note: Note, index: Int, complete: @escaping (Bool) -> ())
    
    func deleteNote(index: Int, complete: @escaping (Bool) -> ())
    
}
