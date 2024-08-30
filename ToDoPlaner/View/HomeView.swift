//
//  HomeView.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 29.08.24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.coreDataService) private var coreDataService: any CoreDataServiceProtocol
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedTaskItem: TaskItem?
    
    init() {
        let coloredNavAppearance = UINavigationBarAppearance()
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .systemGray5
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
           TasksListView(selectedTaskItem: $selectedTaskItem)
                .environmentObject(TasksListViewModel(coreDataService: coreDataService))
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
    HomeView()
        .environment(\.coreDataService, CoreDataService(mainContext: PersistenceController.preview.container.viewContext))
}
