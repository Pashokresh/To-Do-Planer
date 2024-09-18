//
//  TaskEditingView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 04.09.24.
//

import SwiftUI

struct TaskEditingView: View {
    @EnvironmentObject private var taskEditingViewModel: TaskEditingViewModel
    var editedTaskItem: TaskModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TaskEditingView(editedTaskItem: TaskItem.init().transformToTaskModel())
        .environmentObject(
            TasksListViewModel(coreDataService:
                                CoreDataService(persistenceController: PersistenceController.preview)))
}
