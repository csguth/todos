//
//  NoteSheetViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation

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
        
        func setNote(note: Note) {
            self.note = note
            let content = note.content ?? ""
            initialContent = content
            self.content = content
            date = note.date ?? Date()
        }
    }
}
