//
//  FosterHomesViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension FosterHomesView {
    class ViewModel: ObservableObject {
        
        var managedObjectContext: NSManagedObjectContext
        @Published var fosterHomeBeingEdited: FosterHomeEditView.ViewModel
        @Published var isEditing = false
        
        init(ctx: NSManagedObjectContext) {
            managedObjectContext = ctx
            fosterHomeBeingEdited = FosterHomeEditView.ViewModel(with: ctx)
        }
        
        func create() {
            if isEditing {
                return
            }
            fosterHomeBeingEdited = FosterHomeEditView.ViewModel(with: managedObjectContext)
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
