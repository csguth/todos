//
//  NoteStore.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation

class NoteStore: ObservableObject {
    
    let ctx: PersistenceController
    var onCreated: (Note) -> Bool
    
    init (with ctx: PersistenceController) {
        self.ctx = ctx
        self.onCreated = { _ in return false}
    }
    
    @Published var currentNote: Note?
    
    var currentNoteContent: String {
        currentNote?.wrappedContent ?? String()
    }
    
    var currentNoteDate: Date {
        currentNote?.wrappedDate ?? Date()
    }

    func save(_ content: String) -> Bool {
        guard let editing = currentNote else {
            let note = Note(context: ctx.container.viewContext)
            note.id = UUID()
            note.date = Date()
            note.content = content
            guard ctx.save() else { return false }
            guard onCreated(note) else {
                ctx.container.viewContext.delete(note)
                let _ = ctx.save()
                return false
            }
            return true
        }
        editing.content = content
        return ctx.save()
    }
    
}
