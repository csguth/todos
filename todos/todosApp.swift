//
//  todosApp.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

@main
struct todosApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        let persistenceController = PersistenceController.shared
        WindowGroup {
            NavigationView {
                FosterHomesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
