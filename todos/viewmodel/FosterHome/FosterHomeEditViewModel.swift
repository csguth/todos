//
//  EditFosterHomeViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension FosterHomeEditView {
    
    class ViewModel: ObservableObject {
        
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
        
        func reset(fosterHome: FosterHome?) {
            home = fosterHome
            name = fosterHome?.wrappedName ?? ""
            phone = fosterHome?.phone ?? ""
            maleCount = Int(fosterHome?.malesCount ?? 0)
            femaleCount = Int(fosterHome?.femalesCount ?? 0)
            date = fosterHome?.date ?? Date.sevenDaysAgo
        }
        
        func save() {
            guard canSave else {
                return
            }
            var home = self.home
            if home == nil {
                let newHome = FosterHome(context: managedObjectContext)
                newHome.theId = UUID()
                home = newHome
            }
            home!.date = date
            home!.femalesCount = Int32(femaleCount)
            home!.malesCount = Int32(maleCount)
            home!.name = name
            home!.phone = phone
            try! managedObjectContext.save()
        }
        
    }
    
}
