//
//  TaskStatusView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import SwiftUI

struct TaskStatusView: View {
    var status: TaskStatus
    var date: Date?
    
    var body: some View {
        Text(status.title)
            .foregroundStyle(Color.white)
            .bold()
            .multilineTextAlignment(.center)
            .frame(width: 100, height: 30)
            .background {
                Capsule()
                    .fill(status == .complete ? .green : isMissed() ? .red : .yellow)
                    .shadow(radius: 1)
            }
    }
    
    func isMissed() -> Bool {
        if let date = date {
            return date > Date.now
        }
        return false
    }
}

#Preview {
    TaskStatusView(status: .pending, date: Date.now)
}
