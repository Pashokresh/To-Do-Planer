//
//  TaskEditingViewModelTests.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 17.09.24.
//

import XCTest
@testable import ToDoPlaner

final class TaskEditingViewModelTests: XCTestCase {
    
    var coreDataService: (any CoreDataServiceProtocol)?
    var viewModel: TaskEditingViewModel?

    override func setUp() async throws {
        let persistenceController = await PersistenceController.preview
        persistenceController.addPreviewTaskItems()
        
        coreDataService = CoreDataService(persistenceController: persistenceController)
        
        viewModel = await TaskEditingViewModel(coreDataService: coreDataService!)
    }

    override func tearDown() async throws {
        await PersistenceController.preview.deleteAllPreviewTaskItems()
        
        viewModel = nil
        coreDataService = nil
    }

    func testViewModelUpdateTask() async throws {
        let newTask = try await coreDataService?.createNewTask()
        
        XCTAssertNotNil(newTask, "New task is nil")
        
        await viewModel?.updateTask(newTask!, newTitle: someNewName, newComment: someNewComment, newDate: someNewFinishDate, newStatus: completeStatus)
        
        let fetchRequest = TaskItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", newTask!.id! as CVarArg)
        
        let fetchResult = try await coreDataService?.fetchTasks(with: fetchRequest)
        
        XCTAssertNotNil(fetchResult, "Fetch result after update is nil")
        
        XCTAssertEqual(fetchResult?.first?.title, someNewName)
        XCTAssertEqual(fetchResult?.first?.comment, someNewComment)
        XCTAssertEqual(fetchResult?.first?.completeDate, someNewFinishDate)
        XCTAssertEqual(fetchResult?.first?.status, completeStatus)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
