//
//  FosterHomeStore.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import SwiftUI

class FosterHomeStore: ObservableObject, Identifiable {
    
    let ctx: PersistenceController
    
    init (with ctx: PersistenceController) {
        self.ctx = ctx
        self.fosterHome = nil
        note = NoteStore(with: ctx)
    }
    
    @Published var fosterHome: FosterHome?
    @Published var note: NoteStore
    
    var name: String {
        fosterHome?.wrappedName ?? ""
    }
    
    var notesArray: [Note] {
        fosterHome?.notesArray ?? [Note]()
    }
    
    var animals: [AnimalStore] {
        fosterHome?.animalsArray.map {
            let store = AnimalStore(with: ctx)
            store.animal = $0
            return store
        } ?? [AnimalStore]()
    }
    
    var malesCount: Int {
        fosterHome?.malesCount ?? 0
    }
    
    var femalesCount: Int {
        fosterHome?.femalesCount ?? 0
    }
    
    func deleteNotes(indexSet: IndexSet) -> Bool {
        guard let fosterHome = self.fosterHome else { return true }
        indexSet
            .map{ notesArray[$0] }
            .forEach{
                fosterHome.removeFromNotes($0)
                if note.currentNote == $0 { note.currentNote = nil }
            }
        return ctx.save()
    }
    
    func create() -> Bool {
        note.currentNote = nil
        note.onCreated = { note in
            guard let fosterHome = self.fosterHome else { return false }
            fosterHome.addToNotes(note)
            return self.ctx.save()
        }
        return true
    }
    
    func edit(note: Note) -> Bool {
        self.note.currentNote = note
        self.note.onCreated = { _ in return false }
        return true
    }
    
    func createAnimal() -> Bool {
        guard let fosterHome = self.fosterHome else { return false }
        let animal = Animal(context: ctx.container.viewContext)
        animal.fosterHome = fosterHome
        animal.color = ["tabby-gray", "tabby-orange", "tuxedo"].randomElement()
        animal.name = ["Walter White", "Jesse Pinkman", "Gus Fring", "Hank Schrader", "Huell Babineaux", "Todd Alquist",  "Jane Margolis"].randomElement()
        animal.sex = ["M", "F"].randomElement()
        fosterHome.addToAnimals(animal)
        return ctx.save()
    }
    
    
}
