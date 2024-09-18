//
//  TaskEditingViewModel.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 17.09.24.
//

import Foundation
import Combine

@MainActor
class TaskEditingViewModel: ObservableObject {
    
    // MARK: - Data to display
    @Published var error: Error?
    
    // MARK: - Data Management Properties
    private let coreDataService: any CoreDataServiceProtocol
    
    // MARK: - Init method
    init(coreDataService: any CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    // MARK: - Update task
    /// Sets updates to Core Data model
    func updateTask(_ task: TaskModel, newTitle: String?, newComment: String?, newDate: Date?, newStatus: TaskStatus?) async {
        do {
            try await self.coreDataService.updateTask(task, newTitle: newTitle, newComment: newComment, newDate: newDate, newStatus: newStatus)
        } catch {
            print("Task update failed")
            
            await MainActor.run {
                self.error = error
            }
        }
    }
}
