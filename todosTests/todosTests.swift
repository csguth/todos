//
//  todosTests.swift
//  todosTests
//
//  Created by Chrystian Guth on 11/04/2021.
//

import XCTest

import CoreData

@testable import todos

class todosTests: XCTestCase {

    let persistenceController = PersistenceController.preview

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEditingState() throws {
        let persistenceController = PersistenceController.preview
        let viewModel = FosterHomesView.ViewModel(ctx: persistenceController.container.viewContext)
        XCTAssert(!viewModel.isEditing)
        viewModel.create()
        XCTAssert(viewModel.isEditing)
        viewModel.onFinishedEditing()
        XCTAssert(!viewModel.isEditing)
    }
    
    func testDefaultEditFosterHomeViewViewModelIsEmpty() throws {
        let mainModel = EditFosterHomeView.ViewModel(with: persistenceController.container.viewContext)
        XCTAssertNil(mainModel.home)
        XCTAssert(!mainModel.canSave)
        XCTAssertEqual(mainModel.name, "")
        XCTAssertEqual(mainModel.phone, "")

    }
    
    func testAgeInDays() throws {
        let mainModel = EditFosterHomeView.ViewModel(with: persistenceController.container.viewContext)
        mainModel.date = Date().advanced(by: -7 * 24 * 60 * 60)
        XCTAssertEqual(mainModel.age, "7 dias")
        
        mainModel.date = Date().advanced(by: -10 * 24 * 60 * 60)
        XCTAssertEqual(mainModel.age, "10 dias")
        
        mainModel.date = Date().advanced(by: -1 * 24 * 60 * 60)
        XCTAssertEqual(mainModel.age, "1 dia")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
