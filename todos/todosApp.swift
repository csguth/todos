//
//  todosApp.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

@main
struct todosApp: App {
    private let persistenceController: PersistenceController
    @StateObject var state: FosterHomesView.ViewModel
    
    init() {
        let manager = PersistenceController()
        self.persistenceController = manager
        let managedObjectContext = manager.container.viewContext
        let state = FosterHomesView.ViewModel(ctx: managedObjectContext)
        _state = StateObject(wrappedValue: state)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FosterHomesView(fosterHomes: state)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
