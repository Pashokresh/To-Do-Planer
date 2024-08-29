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
    @Binding var selectedTaskItem: TaskItem?
    
    var body: some View {
        List(viewModel.tasks, id: \.self,
             selection: $selectedTaskItem) {
            TaskRowView(task: $0)
                .navigationTitle("ToDos")
        }
    }
}

#Preview {
    TasksListView(selectedTaskItem: .constant(TaskItem.init()))
        .environmentObject(
            TasksListViewModel(coreDataService:
                                CoreDataService(mainContext: PersistenceController.preview.container.viewContext)))
}
