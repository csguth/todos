//
//  EditFosterHomeViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension FosterHomeEditView {
    
    class ViewModel: ObservableObject, Identifiable {
        
        var home: FosterHome? = nil
        let managedObjectContext: NSManagedObjectContext
        
        @Published var name = ""
        @Published var phone = ""
        @Published var maleCount = 0
        @Published var femaleCount = 0
        @Published var date = Date.sevenDaysAgo
        
        init (with ctx: NSManagedObjectContext) {
            managedObjectContext = ctx
        }
        
        init (from fosterHome: FosterHome) {
            home = fosterHome
            managedObjectContext = fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            maleCount = Int(fosterHome.malesCount)
            femaleCount = Int(fosterHome.femalesCount)
            date = fosterHome.date ?? Date.sevenDaysAgo
        }
        

        var canSave: Bool {
            return (
                !name.isEmpty &&
                date.daysBetween(date: Date()) > 0) &&
                (femaleCount + maleCount >= 1) &&
                (
                    (name != home?.name) ||
                    (phone != home?.phone) ||
                    (maleCount != Int(home?.malesCount ?? 0)) ||
                    (femaleCount != Int(home?.femalesCount ?? 0)) ||
                    (date != home?.date)
                )
        }
        
        var age: String {
            let days = date.daysBetween(date: Date())
            let plural = days > 1 ? "s" : ""
            return "\(days) dia\(plural)"
        }
        
    }
    
}
