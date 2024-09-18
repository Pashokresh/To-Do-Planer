//
//  CoreDataService.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 29.08.24.
//

import Foundation
@preconcurrency import CoreData
import Combine
import SwiftUI


struct CoreDataServiceKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: any CoreDataServiceProtocol = DefaultCoreDataService()
}

extension EnvironmentValues {
    var coreDataService: any CoreDataServiceProtocol {
        get { self[CoreDataServiceKey.self] }
        set { self[CoreDataServiceKey.self] = newValue }
    }
}

// MARK: CoreDataServiceProtocol
/// Protocol for work with CoreData
protocol CoreDataServiceProtocol: Sendable {
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskModel]
    func createNewTask() async throws -> TaskModel
    func updateTask(_ task: TaskModel, newTitle: String?, newComment: String?, newDate: Date?, newStatus: TaskStatus?) async throws
}

// MARK: CoreDataServiceProtocol Implementation
actor CoreDataService: CoreDataServiceProtocol {
    private let container: NSPersistentContainer
    
    init(persistenceController: PersistenceController) {
        container = persistenceController.container
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: Protocol methods implementation
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskModel] {
        return try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                do {
                    let taskItems = try context.fetch(fetchRequest)
                    let taskModels = taskItems.map { $0.transformToTaskModel() }
                    continuation.resume(returning: taskModels)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func createNewTask() async throws -> TaskModel {
        return try await container.performBackgroundTask { context in
            let newTask = TaskItem(context: context)
            newTask.id = UUID()
            newTask.dateCreated = Date.now
            newTask.title = "New Task"
            newTask.status = .pending
            
            try context.save()
            return newTask.transformToTaskModel()
        }
    }
    
    func updateTask(_ task: TaskModel, newTitle: String?, newComment: String?, newDate: Date?, newStatus: TaskStatus?) async throws {
        do {
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", (task.id ?? UUID()) as CVarArg)
            
            try await container.performBackgroundTask { context in
                let fetchResult = try context.fetch(fetchRequest)
                if let updatedTask = fetchResult.first {
                    updatedTask.title = newTitle
                    updatedTask.comment = newComment
                    updatedTask.date = newDate
                    updatedTask.status = newStatus ?? .pending
                    
                    try context.save()
                }
            }
        } catch {
            print("Task update is failed in background context: \(error)")
            throw error
        }
    }
}

final class DefaultCoreDataService: CoreDataServiceProtocol {
    func fetchTasks(with fetchRequest: NSFetchRequest<TaskItem>) async throws -> [TaskModel] {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    func createNewTask() async throws -> TaskModel {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    func updateTask(_ task: TaskModel, newTitle: String?, newComment: String?, newDate: Date?, newStatus: TaskStatus?) async throws {
        fatalError("CoreDataService is not provided in the environment.")
    }
    
    
}
