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
        @Published var noteBeingEdited: NoteEditView.ViewModel? = nil
        
        let dateFormatter: DateFormatter
        
        init (for fosterHome: FosterHome, with aDateFormatter: DateFormatter) {
            _fosterHome = Published(wrappedValue: fosterHome)
            dateFormatter = aDateFormatter
        }
        
        var id: UUID {
            fosterHome.id ?? UUID()
        }
        
        var name: String {
            fosterHome.name ?? ""
        }
        
        var isEditingNote: Bool {
            noteBeingEdited != nil
        }
        
        var notes: [Note] {
            fosterHome.notesArray
        }
        
        func edit(note: Note) {
            
        }
        
        
    }
    

}
