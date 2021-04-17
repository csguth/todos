//
//  ContentView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeDetailsView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var fosterHome: ViewModel
    @State var removed = Set<Note>()

    private func createNote() {
        let note = Note(context: managedObjectContext)
        note.id = UUID()
        fosterHome.edit(note: note)
    }
    
    private func deleteNotes(notes: [Note]) {
        notes.forEach{ removed.insert($0) }
        notes.forEach(managedObjectContext.delete)
        try! managedObjectContext.save()
    }
    
    private func addNote(note: Note) {
        fosterHome.fosterHome.addToNotes(note)
        try! managedObjectContext.save()
        fosterHome.isEditingNote = false
    }
    
    var body: some View {
        VStack {
            FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel(for: fosterHome.fosterHome ))
            Spacer()
            if fosterHome.notes.isEmpty {
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!", action: createNote)
                }
            }
            else
            {
                List {
                    ForEach(fosterHome.notes) { note in
                        if !removed.contains(note) {
                            Button(action: {
                                fosterHome.edit(note: note)
                            }, label: {
                                NoteView(note: note)
                            })
                            
                        }
                    }
                    .onDelete(perform: { $0.map{ fosterHome.notes[$0] }.forEach(addNote)})
                }
                .toolbar {
                    Button(action: createNote, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
            Spacer()
        }
        .onAppear {
            removed.removeAll()
        }
        .sheet(isPresented: $fosterHome.isEditingNote) {
            NoteSheetView(note: self.fosterHome.noteBeingEdited, onSaved: addNote)
            .environment(\.managedObjectContext, managedObjectContext)
        }
        .navigationBarTitle(fosterHome.name)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let note1 = Note(context: persistenceController.container.viewContext)
        note1.id = UUID()
        note1.content = "some content"
        note1.date = Date()
        
        let note2 = Note(context: persistenceController.container.viewContext)
        note2.id = UUID()
        note2.content = "asdasd"
        note2.date = Date()
        
        let note3 = Note(context: persistenceController.container.viewContext)
        note3.id = UUID()
        note3.content = "another note"
        note3.date = Date()
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.id = UUID()
        fosterHome.name = "Lt da Leona"
        fosterHome.addToNotes(note1)
        fosterHome.addToNotes(note2)
        fosterHome.addToNotes(note3)
        
        fosterHome.femalesCount = 2
        fosterHome.malesCount = 4
        
        let model = FosterHomeDetailsView.ViewModel(for: fosterHome)
        
        return FosterHomeDetailsView(fosterHome: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
