//
//  PreviewHelper.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import Foundation

/// Class used to provide some data to previews and tests
class PreviewHelper {
    /// First task item from the list of generated for preview task
    static var task: TaskItem? {
        let viewContext = PersistenceController.preview.container.viewContext
        let fetchRequest = TaskItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let result = try? viewContext.fetch(fetchRequest)
        return result?.first
    }
}
