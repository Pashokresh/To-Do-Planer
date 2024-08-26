//
//  ToDoPlanerApp.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import SwiftUI

@main
struct ToDoPlanerApp: App {
    let persistenceController = PersistenceController.preview
    
    var body: some Scene {
        WindowGroup {
            TasksListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(TasksListViewModel(viewContext: persistenceController.container.viewContext))
        }
    }
}
