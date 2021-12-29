//
//  EditFosterHomeViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import CoreData

extension EditFosterHomeView {
    
    class ViewModel: ObservableObject, Identifiable {
        
        var home: FosterHome?
        let managedObjectContext: NSManagedObjectContext
        
        @Published var name: String
        @Published var phone: String
        @Published var date: Date
        
        init (with ctx: NSManagedObjectContext) {
            home = nil
            managedObjectContext = ctx
            name = ""
            phone = ""
            date = Date.sevenDaysAgo
        }
        
        init (from fosterHome: FosterHome) {
            home = fosterHome
            managedObjectContext = fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            date = fosterHome.date ?? Date.sevenDaysAgo
        }

        var canSave: Bool {
            return (
                !name.isEmpty &&
                date.daysBetween(date: Date()) > 0) &&
                (
                    (name != home?.name) ||
                    (phone != home?.phone) ||
                    (date != home?.date)
                )
        }
        
        var age: String {
            let days = date.daysBetween(date: Date())
            let plural = days > 1 ? "s" : ""
            return "\(days) dia\(plural)"
        }
        
        func set(fosterHome: FosterHome?) {
            home = fosterHome
            name = fosterHome?.name ?? ""
            phone = fosterHome?.phone ?? ""
            date = fosterHome?.date ?? Date.sevenDaysAgo
        }
        
    }
    
}
