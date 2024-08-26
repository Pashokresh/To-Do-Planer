//
//  TasksListViewModel.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import CoreData
import Foundation
import Combine

class TasksListViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    @Published var tasks: [TaskItem] = .init()
    @Published var error: Error?
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchTasks()
    }
    
    func fetchTasks() {
        Task {
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TaskItem.date, ascending: true)]
            
            do {
                let result = try self.viewContext.fetch(fetchRequest)
                await MainActor.run {
                    self.tasks = result
                    self.error = nil
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
