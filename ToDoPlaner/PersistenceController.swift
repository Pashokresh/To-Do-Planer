//
//  PersistenceController.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    fileprivate init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoPlaner")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { persistentStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Error by loading persistent stores: \(error), \(error.localizedDescription), \(error.userInfo)")
            }
        }
    }
    
    // Preview setup for SwiftUI previews
    static var preview: PersistencePreviewController = {
        let controller = PersistencePreviewController()
                
        // Example data for previews
        controller.addPreviewTaskItems()
        
        return controller
    }()
}

class PersistencePreviewController: PersistenceController {
    
    init() {
        super.init(inMemory: true)
    }
    
    func addPreviewTaskItems() {
        let viewContext = container.viewContext
        
        for index in 0..<10 {
            let newTask = TaskItem(context: viewContext)
            newTask.title = "Task #\(index + 1)"
            newTask.id = UUID()
            newTask.comment = "New comment"
            newTask.statusRawValue = Int16(index % 2)
            newTask.date = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error by creating preview persistence controller \(nsError), \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
    
    func deleteAllPreviewTaskItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        } catch let error as NSError {
            print("Failed to delete all tasks: \(error), \(error.userInfo)")
        }
        
    }
}
