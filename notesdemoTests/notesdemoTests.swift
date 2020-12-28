//
//  notesdemoTests.swift
//  notesdemoTests
//
//  Created by Nitesh Tak on 27/12/20.
//

import XCTest
@testable import NotesDemo

class notesdemoTests: XCTestCase {
    
    var mockService: MockService!
    var sut: NotesViewModel!
    
    var sutEditModel: NoteEditViewModel!

    override func setUpWithError() throws {

        mockService = MockService()
        sut = NotesViewModel(apiService: mockService)
        
        sutEditModel = NoteEditViewModel(apiService: mockService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockService = nil
    }

    func test_fetch_notes() {
        // When start fetch
        sut.initFetch()

        // Assert
        XCTAssert(mockService!.isFetchNotesCalled)
    }
    
    func test_user_press_on_note() {
        
        if sut.notesList.count == 0 {
            XCTAssertTrue(!sut.isAllowSegue)
        } else {
            //Given a sut with fetched notes
            let indexPath = IndexPath(row: 0, section: 0)

            //When
            sut.userPressed(at: indexPath)
            
            //Assert
            XCTAssertTrue(sut.isAllowSegue)
        }
    }
    
    func test_note_unavailable() {
        // When start fetch
        sut.initFetch()

        // Assert
        XCTAssert(!mockService!.isDeleteNoteCalled)
    }
    
    func test_delete_note() {
        // When start fetch
        sut.initFetch()
        
        if sut.notesList.count == 0 {
            XCTAssertTrue(!mockService!.isDeleteNoteCalled)
        } else {
            //Given a sut with fetched notes
            let indexPath = IndexPath(row: 0, section: 0)

            //When
            sut.deleteNote(index: indexPath.row)
            
            //Assert
            XCTAssertTrue(mockService!.isDeleteNoteCalled)
        }
    }
    
    func test_add_note() {
        sutEditModel.addNewNote()
        
        //Assert
        XCTAssertTrue(mockService!.isAddNoteCalled)
        
        test_update_note()
    }
    
    func test_update_note() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        sutEditModel.saveNote(index: indexPath.row)
        
        //Assert
        XCTAssertTrue(mockService!.isUpdateNoteCalled)
    }

}
