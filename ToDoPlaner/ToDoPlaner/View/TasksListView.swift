//
//  TasksListView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import SwiftUI
import Combine

struct TasksListView: View {
    @EnvironmentObject var viewModel: TasksListViewModel

    var body: some View {
        VStack {
            List(viewModel.tasks) {
                TaskRowView(task: $0)
            }
        }
    }
}

#Preview {
    TasksListView()
        .environmentObject(TasksListViewModel(viewContext: PersistenceController.preview.container.viewContext))
}
