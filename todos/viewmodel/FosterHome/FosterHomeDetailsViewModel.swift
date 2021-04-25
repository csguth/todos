//
//  FosterHomeDetailsViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI
import CoreData

extension FosterHomeDetailsView {
    
    class ViewModel: ObservableObject, Identifiable {
        @Published var fosterHome: FosterHome
        @Published var editNote: NoteEditView.ViewModel
        @Published var summary: FosterHomeSummaryView.ViewModel
        @Published var isEditing = false
        
        let dateFormatter: DateFormatter
        let managedObjectContext: NSManagedObjectContext
        
        init (for fosterHome: FosterHome, with aManagedObjectContext: NSManagedObjectContext, and aDateFormatter: DateFormatter) {
            _fosterHome = Published(wrappedValue: fosterHome)
            managedObjectContext = aManagedObjectContext
            dateFormatter = aDateFormatter
            editNote = NoteEditView.ViewModel(with: aDateFormatter, and: aManagedObjectContext) { _ in
                
            }
            summary = FosterHomeSummaryView.ViewModel(for: fosterHome)
        }
        
        var name: String {
            fosterHome.wrappedName
        }
        
        var notes: [Note] {
            fosterHome.notesArray
        }
        
        var editNotes: [NoteEditView.ViewModel] {
            notes.map{
                NoteEditView.ViewModel(with: dateFormatter, for: $0, performOnSave: onSaved(_:))
            }
        }
        
        private func onSaved(_ aNote: Note?) {
            if let note = aNote {
                fosterHome.addToNotes(note)
                try! managedObjectContext.save()
            }
            isEditing = false
            editNote = NoteEditView.ViewModel(with: dateFormatter, and: fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext, performOnSave: onSaved)
        }
        
        func edit(note: NoteEditView.ViewModel) {
            editNote = note
            isEditing = true
        }
        
        func create() {
            onSaved(nil)
            isEditing = true
        }
        
        func addToNotes(note: Note) {
            fosterHome.addToNotes(note)
            try! managedObjectContext.save()
        }
        
        
    }
    

}
