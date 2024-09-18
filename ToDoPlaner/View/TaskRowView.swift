//
//  TaskRowView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskModel
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                if let title = task.title {
                    Text(title)
                        .font(.title)
                        .fontWeight(.medium)
                }
                
                Text(
                    [task.completeDate?.localized(), task.comment]
                        .compactMap({ $0 })
                        .joined(separator: " ")
                )
            }
            
            Spacer()
            
            TaskStatusView(status: task.status ?? .pending, date: task.completeDate)
            
        }
    }
}

#Preview {
    if let task = PreviewHelper.task {
        TaskRowView(task: task)
    } else {
        Text("Task is not found")
    }
}
