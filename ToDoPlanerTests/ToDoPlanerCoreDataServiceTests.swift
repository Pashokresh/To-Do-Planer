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

    override func setUpWithError() throws {
        coreDataService = CoreDataService(mainContext: PersistenceController.preview.container.viewContext)
        PersistenceController.preview.deleteAllPreviewTaskItems()
        PersistenceController.preview.addPreviewTaskItems()
    }

    override func tearDownWithError() throws {
        PersistenceController.preview.deleteAllPreviewTaskItems()
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
