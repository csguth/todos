//
//  todosApp.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

@main
struct todosApp: App {
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FosterHomesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
