//
//  TaskItem+Extensions.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import Foundation

extension TaskItem {
    enum Status: Int {
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
    
    var status: Status {
        get {
            Status.init(rawValue: Int(statusRawValue)) ?? .pending
        }
        set {
            statusRawValue = Int16(newValue.rawValue)
        }
    }
}
