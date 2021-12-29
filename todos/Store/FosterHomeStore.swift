//
//  FosterHomeStore.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import SwiftUI

class FosterHomeStore: ObservableObject {
    
    @Published var fosterHome: FosterHome
    @Published var noteStore: NoteStore
    
    init (for home: FosterHome) {
        _fosterHome = Published(wrappedValue: home)
        noteStore = NoteStore(fosterHome: home)
    }
    
    var name: String {
        fosterHome.wrappedName
    }
    
    var notesArray: [Note] {
        fosterHome.notesArray
    }
    
    var animals: [AnimalStore] {
        fosterHome.animalsArray.map { AnimalStore(animal: $0) }
    }
    
    var malesCount: Int {
        fosterHome.malesCount
    }
    
    var femalesCount: Int {
        fosterHome.femalesCount
    }
    
    func deleteNotes(indexSet: IndexSet) {
        guard let ctx = fosterHome.managedObjectContext else {
            return
        }
        indexSet
            .map{ notesArray[$0] }
            .forEach{
                fosterHome.removeFromNotes($0)
                if noteStore.currentNote == $0 {
                    noteStore.currentNote = nil
                }
            }
        try! ctx.save()
    }
    
    func create() {
        noteStore.currentNote = nil
    }
    
    func edit(note: Note) {
        noteStore.currentNote = note
    }
    
    func createAnimal() {
        guard let ctx = fosterHome.managedObjectContext else {
            return
        }
        let animal = Animal(context: ctx)
        animal.fosterHome = fosterHome
        animal.color = ["tabby-gray", "tabby-orange", "tuxedo"].randomElement()
        animal.name = ["Walter White", "Jesse Pinkman", "Gus Fring", "Hank Schrader", "Huell Babineaux", "Todd Alquist",  "Jane Margolis"].randomElement()
        animal.sex = ["M", "F"].randomElement()
        fosterHome.addToAnimals(animal)
        try! ctx.save()
    }
    
    
}
