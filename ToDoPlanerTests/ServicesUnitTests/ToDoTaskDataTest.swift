//
//  ToDoTaskDataTest.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 26.08.24.
//

import XCTest
@testable import ToDoPlaner

final class ToDoTaskDataTest: XCTestCase {
    
    private var persistenceController: PersistenceController?

    override func setUp() async throws {
        persistenceController = await PersistenceController.preview
    }
    
    override func tearDown() {
        persistenceController?.deleteAllPreviewTaskItems()
        persistenceController?.addPreviewTaskItems()
        
        persistenceController = nil
    }

    func testBasicTaskItemsFetch() throws {
        let result = try? persistenceController?.container.viewContext.fetch(TaskItem.fetchRequest())
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 10)
    }
    
    @MainActor
    func testAddingSomeNewTaskItem() throws {
        guard let viewContext = persistenceController?.container.viewContext else {
            XCTFail("View Context from PersistenceController is nil")
            return
        }
        
        var result = try? viewContext.fetch(TaskItem.fetchRequest())
        XCTAssertFalse(result?.contains(where: { $0.id == someId }) ?? false, "New task item is already in DB")
        
        let newTaskItem = TaskItem(context: viewContext)
        newTaskItem.id = someId
        newTaskItem.date = someFinishDate
        newTaskItem.dateCreated = Date.now
        newTaskItem.status = pendingStatus
        
        result = try? viewContext.fetch(TaskItem.fetchRequest())
        XCTAssertTrue(result?.contains(where: { $0.id == someId }) ?? false, "New task item is not added in DB")
        
        addTeardownBlock {
            self.persistenceController?.deleteAllPreviewTaskItems()
        }
    }

    func testPerformanceTaskItemsFetch() throws {
        self.measure {
            let _ = try? persistenceController?.container.viewContext.fetch(TaskItem.fetchRequest())
        }
    }

}
