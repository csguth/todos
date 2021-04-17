//
//  FosterHomeDetailsViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

extension FosterHomeDetailsView {
    
    class ViewModel: ObservableObject, Identifiable {
        @Published var fosterHome: FosterHome
        
        init (for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
        }

        @Published var isEditingNote = false
        @Published var noteBeingEdited = NoteSheetView.ViewModel()
        
        var id: UUID {
            fosterHome.id ?? UUID()
        }
        
        var name: String {
            fosterHome.name ?? ""
        }
        
        var notes: [Note] {
            fosterHome.notesArray
        }
        
        func edit(note: Note) {
            self.noteBeingEdited.setNote(note: note)
            isEditingNote = true
        }
    }
    

}
