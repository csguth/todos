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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
