//
//  NoteSheetView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteEditView: View {
    @StateObject var note: ViewModel
    
    @Environment(\.managedObjectContext) var managedObjectContext
            
    var body: some View {
        VStack {
            Text(note.dateText)
            TextEditor(text: $note.content)
                .padding()
            HStack {
                Button("Salvar") {
                    note.save()
                }
                .padding()
                .disabled(!note.canSave)
            }
        }
    }
}

struct NoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let persistance = PersistenceController.preview
        NoteEditView(note: NoteEditView.ViewModel(with: DateFormatter(), and: persistance.container.viewContext))
    }
}
