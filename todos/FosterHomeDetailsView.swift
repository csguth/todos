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

    var body: some View {
        VStack {
            FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel(for: fosterHome.fosterHome ))
            Spacer()
            if fosterHome.notes.isEmpty {
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!", action: {
                        fosterHome.edit(note: nil)
                    })
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
                    .onDelete(perform: { indexSet in
                        indexSet.map{
                            fosterHome.notes[$0]
                        }
                        .forEach {
                            print("delete \($0)")
                            removed.insert($0)
                            managedObjectContext.delete($0)
                            try! managedObjectContext.save()
                        }
                        
                    })
                }
                .toolbar {
                    Button(action: {
                        fosterHome.edit(note: nil)
                    }, label: {
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
            NoteSheetView(note: fosterHome.note) { note in
                fosterHome.fosterHome.addToNotes(note)
                fosterHome.isEditingNote = false
            }
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
