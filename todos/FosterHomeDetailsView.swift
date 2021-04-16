//
//  ContentView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeDetailsView: View {

    @StateObject var fosterHome: ViewModel
    
    var body: some View {
        VStack {
//            FosterHomeSummaryView(
//            )
            Spacer()
            if fosterHome.notes.isEmpty {
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!") {
                        fosterHome.add()
                    }
                }
            }
            else
            {
                List {
                    ForEach(fosterHome.notes) { note in
                        Button(action: {
                           
                        }, label: {
                            NoteView(note: note)
                        })
                    }
                    .onDelete(perform: fosterHome.onDelete)
                }
                .toolbar {
                    Button(action: fosterHome.add, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
            Spacer()
        }
        .sheet(isPresented: $fosterHome.isShowingSheet) {
            NoteSheetView(content: $fosterHome.content, onSaved: fosterHome.onSaved)
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
