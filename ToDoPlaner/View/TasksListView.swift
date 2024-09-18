//
//  TasksListView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import SwiftUI
import Combine

struct TasksListView: View {
    @EnvironmentObject private var viewModel: TasksListViewModel
    @Binding var selectedTaskItem: TaskModel?
    
    var body: some View {
        List(viewModel.tasks, id: \.self,
             selection: $selectedTaskItem) {
            TaskRowView(task: $0)
        }
             .navigationTitle("ToDos")
             .toolbar {
                 Button("Add") {
                     Task {
                         let task = try? await viewModel.createTask()
                         await viewModel.fetchTasks()
                         selectedTaskItem = task
                     }
                 }
             }
    }
}

#Preview {
    TasksListView(selectedTaskItem: .constant(TaskItem.init().transformToTaskModel()))
        .environmentObject(
            TasksListViewModel(coreDataService:
                                CoreDataService(persistenceController: PersistenceController.preview)))
}
