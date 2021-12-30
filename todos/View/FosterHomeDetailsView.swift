//
//  ContentView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeDetailsView: View {

    @EnvironmentObject var store: FosterHomeStore
    @State var editing: Bool = false
    
    private func create() {
        guard store.create() else { return }
        editing = true
    }
    
    private func delete(indexSet: IndexSet) {
        guard store.deleteNotes(indexSet: indexSet) else { return }
    }
    
    private func edit(_ note: Note) {
        guard store.edit(note: note) else { return }
        editing = true
    }

    var body: some View {
        VStack {
            FosterHomeSummaryView()
                .environmentObject(store)
            if store.notesArray.isEmpty {
                Spacer()
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!", action: create)
                }
            }
            else
            {
                List {
                    ForEach(store.notesArray) { note in
                        Button(action: { edit(note) }, label: {
                            NoteView(note: note)
                        })
                    }
                    .onDelete(perform: delete)
                }
                .toolbar {
                    Button(action: create, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
            Spacer()


        }
        .sheet(isPresented: $editing) {
            NoteSheetView().environmentObject(store.note)
        }
        .navigationBarTitle(store.name)
        
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
        
        let leona = Animal(context: persistenceController.container.viewContext)
        leona.name = "Leona"
        leona.fosterHome = fosterHome
        
        let store = FosterHomeStore(with: persistenceController)
        store.fosterHome = fosterHome

        return FosterHomeDetailsView()
            .environmentObject(store)
    }
}
