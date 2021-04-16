//
//  FosterHomeDetailsViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

extension FosterHomeDetailsView {
    
    class ViewModel: ObservableObject, Identifiable {
        @Environment(\.managedObjectContext) var managedObjectContext
        @Published var fosterHome: FosterHome?

        @State var isShowingSheet = false
        @State var content = ""
        @State var selected: Note? = nil
        
        init(for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
        }
        
        var id: UUID {
            fosterHome?.id ?? UUID()
        }
        
        var name: String {
            fosterHome?.name ?? ""
        }
        
        var notes: [Note] {
            fosterHome?.notesArray ?? [Note]()
        }
        
        

        func onDelete(indexSet: IndexSet) {
            for offset in indexSet.sorted().reversed() {
                if let noteToDelete = fosterHome?.notesArray[offset] {
                    fosterHome?.removeFromNotes(noteToDelete)
                }
                
            }
        }
        
        func onSaved(date: Date, content: String) {
            if selected != nil {
                selected?.date = date
                selected?.content = content
                selected = nil
                return
            }
//            let newNote = Note(context: managedObjectContext)
//            newNote.id = UUID()
//            newNote.date = date
//            newNote.content = content
//            fosterHome.addToNotes(newNote)
            
        }
        
        func add() {
            self.fosterHome = nil
            
        }
        
        func edit(fosterHome: FosterHome?) {
            self.fosterHome = fosterHome
            isShowingSheet = true
        }
    }
    

}
