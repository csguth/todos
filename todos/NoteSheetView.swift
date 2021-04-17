//
//  NoteSheetView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

extension NoteSheetView {
    class ViewModel: ObservableObject {
        @Published var note: Note?
        var initialContent = ""
        @Published var content = ""
        @Published var date = Date()
        
        let dateFormatter = DateFormatter()
        
        init() {
            dateFormatter.dateFormat = "dd/MM/yy"
        }
        
        var canSave: Bool {
            content != initialContent
        }
        
        var dateText: String {
            dateFormatter.string(from: date)
        }
        
        func setNote(note: Note?) {
            self.note = note
            let content = note?.content ?? ""
            initialContent = content
            self.content = content
            date = note?.date ?? Date()
        }
    }
}

struct NoteSheetView: View {
    @StateObject var note: ViewModel
    
    let onSaved: () -> Void
    
    var body: some View {
        VStack {
            Text(note.dateText)
            TextEditor(text: $note.content)
                .padding()
            HStack {
                Button("Save") {
                    onSaved()
                }
                .padding()
                .disabled(!note.canSave)
            }
        }
    }
}

struct NoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSheetView(note: NoteSheetView.ViewModel()) {
            
        }
    }
}
