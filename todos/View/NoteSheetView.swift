//
//  NoteSheetView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteSheetView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var note: NoteStore
    @State var content = String()
    
    func toText(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    func save() {
        guard note.save(content) else { return }
        presentationMode.wrappedValue.dismiss()
    }
    
    var canSave: Bool {
        !content.isEmpty && content != note.currentNote?.wrappedContent
    }

    var body: some View {
        VStack {
            Text(toText(note.currentNoteDate))
            TextEditor(text: $content)
                .padding()
            HStack {
                Button("Salvar", action: save)
                .padding()
                .disabled(!canSave)
            }
        }
        .onAppear { content = note.currentNoteContent }
        
    }
}

struct NoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
    }
}
