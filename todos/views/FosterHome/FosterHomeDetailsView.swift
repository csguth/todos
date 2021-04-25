//
//  ContentView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

struct FosterHomeDetailsView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var fosterHome: ViewModel
    @State var removed = Set<Note>()
    
    var editNotes: [NoteEditView.ViewModel] {
        fosterHome.editNotes.filter {
            return $0.note != nil && !removed.contains($0.note!)
        }
    }
    
    private func deleteNotes(indexSet: IndexSet) {
        let notes = Set(indexSet.map{ fosterHome.notes[$0] })
        notes.forEach{removed.insert($0)}
        notes.forEach(fosterHome.fosterHome.removeFromNotes)
        notes.forEach(managedObjectContext.delete)
    }
    
    var body: some View {
        VStack {
            FosterHomeSummaryView(fosterHome: fosterHome.summary)
            Spacer()
            if fosterHome.notes.isEmpty {
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!", action: fosterHome.create)
                }
            }
            else
            {
                List {
                    ForEach(editNotes) { note in
                        Button(action: { fosterHome.edit(note: note) }) {
                            NoteCardView(for: note.note ?? Note())
                        }
                    }
                    .onDelete(perform: deleteNotes)
                }
                .toolbar {
                    Button(action: fosterHome.create, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                    
                }
            }
            Spacer()
        }
        .onAppear {
            removed.removeAll()
        }
        .onDisappear {
            try! managedObjectContext.save()
        }
        .sheet(isPresented: $fosterHome.isEditing) {
            NoteEditView(note: fosterHome.editNote)
            .environment(\.managedObjectContext, managedObjectContext)
        }
        .navigationBarTitle(fosterHome.name)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let note1 = Note(context: persistenceController.container.viewContext)
        note1.theId = UUID()
        note1.content = "some content"
        note1.date = Date()
        
        let note2 = Note(context: persistenceController.container.viewContext)
        note2.theId = UUID()
        note2.content = "asdasd"
        note2.date = Date()
        
        let note3 = Note(context: persistenceController.container.viewContext)
        note3.theId = UUID()
        note3.content = "another note"
        note3.date = Date()
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.theId = UUID()
        fosterHome.name = "Lt da Leona"
        fosterHome.addToNotes(note1)
        fosterHome.addToNotes(note2)
        fosterHome.addToNotes(note3)
        
        fosterHome.femalesCount = 2
        fosterHome.malesCount = 4
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:ii"
        
        let model = FosterHomeDetailsView.ViewModel(for: fosterHome, with: persistenceController.container.viewContext, and: dateFormatter)
        
        return FosterHomeDetailsView(fosterHome: model)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
