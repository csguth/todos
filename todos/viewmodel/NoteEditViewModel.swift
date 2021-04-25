//
//  NoteSheetViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension NoteEditView {
    class ViewModel: ObservableObject, Identifiable {
        let dateFormatter: DateFormatter
        let managedObjectContext: NSManagedObjectContext
        
        @Published var note: Note? = nil
        @Published var content = ""
        let onSaved: (Note) -> Void
        
        init(with aDateFormatter: DateFormatter, for aNote: Note, performOnSave onSavedCallback: @escaping (Note) -> Void) {
            dateFormatter = aDateFormatter
            managedObjectContext = aNote.managedObjectContext ?? PersistenceController.shared.container.viewContext
            note = aNote
            content = aNote.wrappedContent
            onSaved = onSavedCallback
        }
        
        init(with aDateFormatter: DateFormatter, and aManagedObjectContext: NSManagedObjectContext, performOnSave onSavedCallback: @escaping (Note) -> Void) {
            dateFormatter = aDateFormatter
            managedObjectContext = aManagedObjectContext
            onSaved = onSavedCallback
        }
        
        var canSave: Bool {
            content != note?.content && !content.isEmpty
        }
        
        var dateText: String {
            dateFormatter.string(from: note?.date ?? Date())
        }
        
        func save() {
            guard canSave else {
                return
            }
            var note = self.note
            if note == nil {
                let newNote = Note(context: managedObjectContext)
                newNote.theId = UUID()
                note = newNote
            }
            note!.date = Date()
            note!.content = content
            try! managedObjectContext.save()
            onSaved(note!)
        }
    }
}
