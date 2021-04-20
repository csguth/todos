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
    
    private func deleteNote(note: Note) {
        removed.insert(note)
        managedObjectContext.delete(note)
        try! managedObjectContext.save()
    }
    
    private func addNote(note: Note) {
        fosterHome.fosterHome.addToNotes(note)
        try! managedObjectContext.save()
//        fosterHome.isEditingNote = false
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
                                NoteCardView(for: note)
                            })
                            
                        }
                    }
                    .onDelete(perform: { indexSet in
                        
                        let notes = indexSet.map{ fosterHome.notes[$0] }
                        notes.forEach(deleteNote)
                        
                    })
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
        .sheet(isPresented: .constant(true)) {
            NoteEditView(note: fosterHome.noteBeingEdited as! NoteEditView.ViewModel)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:ii"
        
        let model = FosterHomeDetailsView.ViewModel(for: fosterHome, with: dateFormatter)
        
        return FosterHomeDetailsView(fosterHome: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
