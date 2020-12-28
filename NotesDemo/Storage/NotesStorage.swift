//
//  NotesStorage.swift
//  notesdemo
//
//  Created by Nitesh Tak on 28/12/20.
//

import Foundation

class Storage {
    
    let NOTES_KEY = "SavedNotesList"
    
    public static var shared: Storage {
        get {
            if _shared == nil {
                _shared = Storage()
            }
            return _shared!
        }
    }
    
    private static var _shared: Storage? = nil
    
    public class func set(shared: Storage) {
        _shared = shared
    }
    
    public init() {
        if retreiveItems().count == 0 {
            //Storing Items
            storeItems(notes: [Note]())
        }
    }
    
    func saveExistingNote(note: Note, index: Int) {
        var items = retreiveItems()
        items[index] = note
        storeItems(notes: items)
    }
    
    func deleteExistingNote(index: Int) {
        var items = retreiveItems()
        items.remove(at: index)
        storeItems(notes: items)
    }
    
    func addNewNote(note: Note) {
        var items = retreiveItems()
        items.append(note)
        storeItems(notes: items)
    }
    
    func getAllNotes() -> [Note] {
        return retreiveItems()
    }
    
    func storeItems(notes: [Note]) {
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(notes)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: NOTES_KEY)

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    func retreiveItems() -> [Note] {
        //Retrieving Items
        if let data = UserDefaults.standard.data(forKey: NOTES_KEY) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let notes = try decoder.decode([Note].self, from: data)
                return notes
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return []
    }
}
