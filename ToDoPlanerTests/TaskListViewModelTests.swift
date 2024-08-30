//
//  TaskListViewModelTests.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 29.08.24.
//

import XCTest
@testable import ToDoPlaner

final class TaskListViewModelTests: XCTestCase {
    
    var coreDataService: (any CoreDataServiceProtocol)?
    var viewModel: TasksListViewModel?

    override func setUpWithError() throws {
        let persistenceController = PersistenceController.preview
        persistenceController.addPreviewTaskItems()
        
        coreDataService = CoreDataService(mainContext: persistenceController.container.viewContext)
        
        viewModel = TasksListViewModel(coreDataService: coreDataService!)
    }

    override func tearDownWithError() throws {
        PersistenceController.preview.deleteAllPreviewTaskItems()
        
        viewModel = nil
        coreDataService = nil
    }

    func testViewModelTasksFetch() throws {
        let expectation = self.expectation(description: "Fetch Tasks Expectation")
        
        viewModel?.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !(self.viewModel?.tasks.isEmpty ?? true) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
                
        XCTAssertFalse(viewModel?.tasks.isEmpty ?? true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
