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
    @State private var selectedTaskItem: TaskItem?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    init() {
        let coloredNavAppearance = UINavigationBarAppearance()
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .systemOrange
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(viewModel.tasks, id: \.self, selection: $selectedTaskItem) {
                TaskRowView(task: $0)
                    .navigationTitle("ToDos")
            }
        } detail: {
            if let selected = selectedTaskItem {
                Text(selected.title ?? "Hey")
                    .navigationTitle("Details")
            } else {
                Text("Select task")
                    .navigationTitle("Details")
            }
            
        }
        .navigationSplitViewStyle(.balanced)
        
    }
}

#Preview {
    TasksListView()
        .environmentObject(TasksListViewModel(viewContext: PersistenceController.preview.container.viewContext))
}
