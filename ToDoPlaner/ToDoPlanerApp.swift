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
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.coreDataService, CoreDataService(mainContext: persistenceController.container.viewContext))
        }
    }
}
