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
    private let dateFormatter: DateFormatter
    private let fosterHomes: FosterHomesView.ViewModel
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:ii"
        fosterHomes = FosterHomesView.ViewModel(ctx: persistenceController.container.viewContext, and: dateFormatter)
        self.dateFormatter = dateFormatter
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FosterHomesView(fosterHomes: fosterHomes, dateFormatter: dateFormatter)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
