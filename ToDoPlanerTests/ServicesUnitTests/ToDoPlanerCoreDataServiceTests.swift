//
//  ToDoPlanerCoreDataServiceTests.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 30.08.24.
//

import XCTest
@testable import ToDoPlaner
import CoreData

final class ToDoPlanerCoreDataServiceTests: XCTestCase {
    
    var coreDataService: (any CoreDataServiceProtocol)?

    override func setUp() async throws {
        coreDataService = CoreDataService(persistenceController: await PersistenceController.preview)
        await PersistenceController.preview.deleteAllPreviewTaskItems()
        await PersistenceController.preview.addPreviewTaskItems()
    }

    override func tearDown() async throws {
        await PersistenceController.preview.deleteAllPreviewTaskItems()
        coreDataService = nil
    }

    func testFetchTaskItems() async throws {
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        
        let result = try? await coreDataService?.fetchTasks(with: fetchRequest)
        
        XCTAssertNotNil(result, "Fetch result is nil")
        
        XCTAssertEqual(result?.count ?? 0, 10)
    }
    
    func testCreateNewTaskItem() async throws {
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        
        var fetchResult = try await coreDataService?.fetchTasks(with: fetchRequest)
        
        XCTAssertNotNil(fetchResult, "Fetch result is nil")
        
        XCTAssertFalse(fetchResult?.contains(where: { $0.title == "New Task" }) ?? true)
        
        _ = try await coreDataService?.createNewTask()
        
        fetchResult = try await coreDataService?.fetchTasks(with: fetchRequest)
        
        XCTAssertTrue(fetchResult?.contains(where: { $0.title == "New Task" }) ?? false)
    }
    
    func testUpdateTaskItem() async throws {
        let newTask = try await coreDataService?.createNewTask()
        
        XCTAssertNotNil(newTask, "New task is nil")
        
        XCTAssertNotEqual(newTask?.title, someNewName, "New task already has new name")
        XCTAssertNotEqual(newTask?.comment, someNewComment, "New task already has new comment")
        XCTAssertNotEqual(newTask?.completeDate, someNewFinishDate, "New task already has new finish date")
        XCTAssertNotEqual(newTask?.status, completeStatus, "New task already has `complete` status")
        XCTAssertNotEqual(newTask?.title, someNewName, "New task already has new name")
        
        try await coreDataService?.updateTask(newTask!, newTitle: someNewName, newComment: someNewComment, newDate: someNewFinishDate, newStatus: completeStatus)
        
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", newTask!.id! as CVarArg)
        
        let fetchResult = try await coreDataService?.fetchTasks(with: fetchRequest)
        
        XCTAssertNotNil(fetchResult, "Fetch result is nil")
        
        XCTAssertEqual(fetchResult?.first?.title, someNewName, "New task has old name")
        XCTAssertEqual(fetchResult?.first?.comment, someNewComment, "New task has old comment")
        XCTAssertEqual(fetchResult?.first?.completeDate, someNewFinishDate, "New task has old finish date")
        XCTAssertEqual(fetchResult?.first?.status, completeStatus, "New task has `pending` status")
        XCTAssertEqual(fetchResult?.first?.title, someNewName, "New task has old name")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
