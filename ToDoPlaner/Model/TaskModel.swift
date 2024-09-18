//
//  TaskModel.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 17.09.24.
//

import Foundation

struct TaskModel: Sendable {
    let id: UUID?
    let title: String?
    let creationDate: Date?
    let completeDate: Date?
    let status: TaskStatus?
    let comment: String?
}

extension TaskModel: Hashable, Identifiable {
    
}
