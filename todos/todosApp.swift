//
//  todosApp.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

@main
struct todosApp: App {
   
    let store = ApplicationStore(with: PersistenceController.shared)
        
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FosterHomesView()
                    .environmentObject(store)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
            
        }
    }
}
