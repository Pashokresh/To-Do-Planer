//
//  CoreDataService.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 29.08.24.
//

import Foundation
import CoreData
import Combine
import SwiftUI


struct CoreDataServiceKey: EnvironmentKey {
    static let defaultValue: any CoreDataServiceProtocol = DefaultCoreDataService()
}

extension EnvironmentValues {
    var coreDataService: any CoreDataServiceProtocol {
        get { self[CoreDataServiceKey.self] }
        set { self[CoreDataServiceKey.self] = newValue }
    }
}

// MARK: CoreDataServiceProtocol
/// Protocol for work with CoreData
protocol CoreDataServiceProtocol: ObservableObject {
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskItem]
    func createNewTask() async throws -> TaskItem
    func updateTask() async throws
}

// MARK: CoreDataServiceProtocol Implementation
class CoreDataService: CoreDataServiceProtocol {
    
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    private var cancellable = Set<AnyCancellable>()
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.parent = self.mainContext
        
        setupChildContextObserver()
    }
    
    // MARK: - Child NSManagedObjectContext settings
    /// Function to setup notifications on save changes in `mainContext` after applying them in `mainContext`
    private func setupChildContextObserver() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: backgroundContext)
            .sink { [weak self] notification in
                guard let userInfo = notification.userInfo else { return }
                
                Task { [weak self] in
                    try await self?.mergeChangesInMainContext(from: userInfo)
                }
            }
            .store(in: &cancellable)
    }
    
    /// Merges changes from `backgroundContext` to `mainContext`
    private func mergeChangesInMainContext(from userInfo: [AnyHashable: Any]) async throws {
        try await mainContext.perform {
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [self.mainContext])
            
            if self.mainContext.hasChanges {
                try self.mainContext.save()
            }
        }
    }
    
    //MARK: Protocol methods implementation
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskItem] {
        return try await backgroundContext.perform {
            return try self.backgroundContext.fetch(fetchRequest)
        }
    }
    
    func createNewTask() async throws -> TaskItem {
        return try await backgroundContext.perform {
            let newTask = TaskItem(context: self.backgroundContext)
            newTask.id = UUID()
            newTask.dateCreated = Date.now
            newTask.title = "New Task"
            newTask.status = .pending
            
            try self.backgroundContext.save()
            return newTask
        }
    }
    
    func updateTask() async throws {
        
    }
}

class DefaultCoreDataService: CoreDataServiceProtocol {
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskItem] {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    func createNewTask() async throws -> TaskItem {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    func updateTask() async throws {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    
}
