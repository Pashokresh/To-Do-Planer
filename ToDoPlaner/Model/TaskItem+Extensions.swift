//
//  TaskItem+Extensions.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import Foundation

extension TaskItem {
    
    var status: TaskStatus {
        get {
            TaskStatus.init(rawValue: Int(statusRawValue)) ?? .pending
        }
        set {
            statusRawValue = Int16(newValue.rawValue)
        }
    }
    
    func transformToTaskModel() -> TaskModel {
        TaskModel(id: id, title: title, creationDate: dateCreated, completeDate: date, status: status, comment: comment)
    }
}
