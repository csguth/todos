//
//  ApplicationStore.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import CoreData

class ApplicationStore: ObservableObject {
    
    let ctx: PersistenceController
    
    init (with ctx: PersistenceController) {
        self.ctx = ctx
    }
    
    @Published var currentFosterHome: FosterHome?
    
    var currentDate: Date {
        currentFosterHome?.date ?? Date.sevenDaysAgo
    }
    
    func edit(fosterHome: FosterHome) {
        currentFosterHome = fosterHome
    }
    
    func createFosterHome() {
        currentFosterHome = nil
    }
    
    func cancel() {
        currentFosterHome = nil
    }
    
    func delete(fosterHome: FosterHome) {
        ctx.container.viewContext.delete(fosterHome)
    }
    
    func canSave(name: String, phone: String, date: Date) -> Bool {
        return (date.daysBetween(date: Date()) > 0) &&
        (
            (name != currentFosterHome?.name) ||
            (phone != currentFosterHome?.phone) ||
            (date != currentDate)
        )
    }
    
    func storeFor(home: FosterHome) -> FosterHomeStore {
        let store = FosterHomeStore(with: ctx)
        store.fosterHome = home
        return store
    }
    
    var currentOrNew: FosterHome {
        guard let fosterHome = currentFosterHome else {
            let fosterHome = FosterHome(context: ctx.container.viewContext)
            fosterHome.id = UUID()
            return fosterHome
        }
        return fosterHome
    }
    
    func save(name: String, phone: String, date: Date) -> Bool {
        let fosterHome = currentOrNew
        fosterHome.name = name
        fosterHome.phone = phone
        fosterHome.date = date
        return ctx.save()
    }
    
}
