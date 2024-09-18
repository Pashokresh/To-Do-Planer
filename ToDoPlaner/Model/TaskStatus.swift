//
//  TaskStatus.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 17.09.24.
//

import Foundation

enum TaskStatus: Int {
    case pending = 0
    case complete = 1
    
    var title: String {
        switch self {
        case .complete:
            return "Complete"
        case .pending:
            return "Pending"
        }
    }
}
