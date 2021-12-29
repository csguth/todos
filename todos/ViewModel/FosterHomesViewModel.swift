//
//  FosterHomesViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import CoreData

extension FosterHomesView {
    class ViewModel: ObservableObject {
        
        var managedObjectContext: NSManagedObjectContext
        @Published var fosterHomeBeingEdited: EditFosterHomeView.ViewModel
        @Published var isEditing = false
        
        init(ctx: NSManagedObjectContext) {
            managedObjectContext = ctx
            fosterHomeBeingEdited = EditFosterHomeView.ViewModel(with: ctx)
        }
        
        func create() {
            if isEditing {
                return
            }
            fosterHomeBeingEdited.set(fosterHome: nil)
            isEditing = true
        }
        
        func onFinishedEditing() {
            isEditing = false
        }
        
        
        func deleteFosterHome(fosterHome: FosterHome) {
            managedObjectContext.delete(fosterHome)
            try! managedObjectContext.save()
        }
    }
}
