//
//  NoteSheetView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteSheetView: View {
    @StateObject var note: ViewModel
    
    @Environment(\.managedObjectContext) var managedObjectContext
        
    let onSaved: (Note) -> Void
    
    var body: some View {
        VStack {
            Text(note.dateText)
            TextEditor(text: $note.content)
                .padding()
            HStack {
                Button("Salvar") {
                    if note.note == nil {
                        let note = Note(context: managedObjectContext)
                        note.id = UUID()
                        self.note.note = note
                    }
                    let note = self.note.note!
                    note.date = self.note.date
                    note.content = self.note.content
                    try? managedObjectContext.save()
                    onSaved(note)
                }
                .padding()
                .disabled(!note.canSave)
            }
        }
    }
}

struct NoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSheetView(note: NoteSheetView.ViewModel()) {_ in 
            
        }
    }
}
