//
//  TaskListViewModelTests.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 29.08.24.
//

import XCTest
@testable import ToDoPlaner

final class TaskListViewModelTests: XCTestCase {
    
    var persistenceController: PersistencePreviewController?
    var viewModel: TasksListViewModel?

    override func setUpWithError() throws {
        persistenceController = PersistenceController.preview
        persistenceController?.addPreviewTaskItems()
        guard let persistenceController = persistenceController else { throw XCTestError(.failureWhileWaiting, userInfo: ["PersistenceController": "PersistenceController is nil"]) }
        
        viewModel = TasksListViewModel(viewContext: persistenceController.container.viewContext)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        persistenceController?.deleteAllPreviewTaskItems()
        persistenceController = nil
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
    
    func testViewModelNewTaskCreation() throws {
        let expectation = self.expectation(description: "Fetch Tasks To Check Contain Expectation")
        
        viewModel?.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !(self.viewModel?.tasks.isEmpty ?? true) {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
                
        XCTAssertFalse(viewModel?.tasks.contains(where: { $0.title == "New title" }) ?? true)
        
        let anotherExpectation = self.expectation(description: "Fetch Tasks To Check Contain Expectation")
        
        viewModel?.createNewTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !(self.viewModel?.tasks.isEmpty ?? true) {
                anotherExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssertTrue(viewModel?.tasks.contains(where: { $0.title == "New title" }) ?? false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
