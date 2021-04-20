//
//  NoteSheetViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension NoteEditView {
    class ViewModel: ObservableObject {
        let dateFormatter: DateFormatter
        let managedObjectContext: NSManagedObjectContext
        
        @Published var note: Note? = nil
        @Published var content = ""
        
        init(with aDateFormatter: DateFormatter, for aNote: Note) {
            dateFormatter = aDateFormatter
            managedObjectContext = aNote.managedObjectContext ?? PersistenceController.shared.container.viewContext
            note = aNote
            content = note?.content ?? ""
        }
        
        init(with aDateFormatter: DateFormatter, and aManagedObjectContext: NSManagedObjectContext) {
            dateFormatter = aDateFormatter
            managedObjectContext = aManagedObjectContext
        }
        
        var canSave: Bool {
            content != note?.content && !content.isEmpty
        }
        
        var dateText: String {
            dateFormatter.string(from: note?.date ?? Date())
        }
        
        func save() {
            var note = self.note
            if note == nil {
                let newNote = Note(context: managedObjectContext)
                newNote.id = UUID()
                note = newNote
            }
            note!.date = Date()
            note!.content = content
            try? managedObjectContext.save()
        }
    }
}
