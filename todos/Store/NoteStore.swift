//
//  NoteStore.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation

class NoteStore: ObservableObject {
    
    @Published var fosterHome: FosterHome
    
    init (fosterHome: FosterHome) {
        _fosterHome = Published(wrappedValue: fosterHome)
    }
    
    @Published var currentNote: Note?
    
    var currentNoteContent: String {
        currentNote?.wrappedContent ?? String()
    }
    
    var currentNoteDate: Date {
        currentNote?.wrappedDate ?? Date()
    }

    func save(_ content: String) {
        guard let ctx = fosterHome.managedObjectContext else {
            return
        }
        guard let editing = currentNote else {
            let note = Note(context: ctx)
            note.id = UUID()
            note.date = Date()
            note.content = content
            fosterHome.addToNotes(note)
            try! note.managedObjectContext?.save()
            return
        }
        editing.content = content
        try! editing.managedObjectContext?.save()
    }
    
}
