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
    
    //MARK: Data to display
    @Published var tasks: [TaskItem] = .init()
    @Published var error: Error?
    
    //MARK: Private properties for Data management
    private var coreDataService: any CoreDataServiceProtocol
    
    // MARK: - Init method
    init(coreDataService: any CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
        
        fetchTasks()
    }
    
    // MARK: Fetch tasks
    /// Fetches a list of `TaskItem` from DataBase sorted by the date of creation
    func fetchTasks() {
        Task {
            do {
                let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TaskItem.date, ascending: true)]
                
                let result = try await self.coreDataService.fetchTasks(with: fetchRequest)
                
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
