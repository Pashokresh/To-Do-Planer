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
    
    private init(inMemory: Bool = false) {
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
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Example data for previews
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
        
        return controller
    }()
}
