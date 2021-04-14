//
//  ContentView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeDetailsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var fosterHome: FosterHome
    @State private var showingSheet = false
    @State private var content = ""
    @State private var selected: Note? = nil
    
    init (for fosterHome: FosterHome) {
        _fosterHome = ObservedObject(wrappedValue: fosterHome)
    }
        
    private func add(note: Note?) {
        selected = note
        content = note?.wrappedContent ?? ""
        showingSheet.toggle()
    }
    
    private func onSaved(date: Date, content: String) {
        if selected != nil {
            selected?.date = date
            selected?.content = content
            selected = nil
            return
        }
        let newNote = Note(context: managedObjectContext)
        newNote.id = UUID()
        newNote.date = date
        newNote.content = content
        fosterHome.addToNotes(newNote)
        
    }
    
    private var sexText: String {
        var males = ""
        if fosterHome.malesCount > 0 {
            males = "\(fosterHome.malesCount)M "
        }
        var plus = ""
        if fosterHome.malesCount > 0 && fosterHome.femalesCount > 0 {
            plus = "+ "
        }
        var females = ""
        if fosterHome.femalesCount > 0 {
            females = "\(fosterHome.femalesCount)F"
        }
        return males + plus + females
    }
    
    var body: some View {
        VStack {
            Text(sexText)
            Spacer()
            if fosterHome.notes?.count == 0 {
                VStack {
                    Text("Sem notas")
                    Button("Criar uma!") {
                        self.add(note: nil)
                    }
                }
            }
            else
            {
                List {
                    ForEach(fosterHome.notesArray, id: \.self) { note in
                        Button(action: {
                            self.add(note: note)
                        }, label: {
                            NoteView(note: note)
                        })
                    }
                    .onDelete(perform: { indexSet in
                        for offset in indexSet.sorted().reversed() {
                            let noteToDelete = fosterHome.notesArray[offset]
                            fosterHome.removeFromNotes(noteToDelete)
                        }
                    })
                }

                .toolbar {
                    Button(action: {
                        self.add(note: nil)
                    }, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
            Spacer()
        }
        .sheet(isPresented: $showingSheet) {
            NoteSheetView(content: $content, onSaved: onSaved)
        }
        .navigationBarTitle(fosterHome.wrappedName)
        
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

        return FosterHomeDetailsView(for: fosterHome)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
