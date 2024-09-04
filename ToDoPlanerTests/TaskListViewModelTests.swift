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
        
        addTeardownBlock {
            PersistenceController.preview.deleteAllPreviewTaskItems()
        }
    }
    
    func testViewModelAddNewTask() async throws {
        // Initial expectation for fetching tasks
        let initialFetchExpectation = expectation(description: "Initial Fetch Tasks Expectation")
        
        // Fetch initial tasks
        viewModel?.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !(self.viewModel?.tasks.isEmpty ?? true) {
                initialFetchExpectation.fulfill()
            }
        }
        
        await fulfillment(of: [initialFetchExpectation], timeout: 5.0)
            
        // Assert that inital number of tasks is 10
        XCTAssertEqual(viewModel?.tasks.count, 10, "Initial number of tasks is wrong")
        
        // Expectation for additing new task
        let addTaskExpectation = self.expectation(description: "Add New Task Expectation")
        
        // Add a new task
        let newTask = try await viewModel?.createTask();
        
        // Fetch tasks again to verify the new task was added
        viewModel?.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let tasks = self.viewModel?.tasks, tasks.contains(where: { $0.id == newTask?.id }) {
                        addTaskExpectation.fulfill()
            }
        }
        
        await fulfillment(of: [addTaskExpectation], timeout: 5.0)
        
        // Assert that new task was added
        XCTAssertTrue(viewModel?.tasks.contains(where: { $0.id == newTask?.id }) ?? false, "New Task was not found")
        
        addTeardownBlock {
            PersistenceController.preview.deleteAllPreviewTaskItems()
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
