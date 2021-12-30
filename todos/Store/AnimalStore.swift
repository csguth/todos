//
//  AnimalStore.swift
//  todos
//
//  Created by Chrystian Guth on 28/12/2021.
//

import Foundation
import SwiftUI
import CoreData

class AnimalStore: ObservableObject, Identifiable {
    
    let ctx: PersistenceController
    
    init (with ctx: PersistenceController) {
        self.ctx = ctx
    }
    
    @Published var animal: Animal?

    private func adopt(who: String) -> Bool {
        guard let animal = self.animal else { return false }
        let adoption = Adoption(context: ctx.container.viewContext)
        adoption.date = Date()
        adoption.name = who
        animal.addToAdoptions(adoption)
        guard ctx.save() else { return false }
        self.animal = animal
        return true
    }
    
    public func rehome() -> Bool {
        guard let animal = self.animal else { return false }
        guard let firstAdoption = animal.adoptionsArray.first else { return adopt(who: "Foo") }
        animal.removeFromAdoptions(firstAdoption)
        guard ctx.save() else { return false }
        self.animal = animal
        return true
    }
    
    public func changeColor() -> Bool {
        let colors: [Animal.Color] = [.tabby_orange, .tabby_gray, .tuxedo]
        guard let index = colors.firstIndex(of: color) else { return false }
        guard let animal = self.animal else { return false }
        animal.wrappedColor = colors[(index+1)%colors.count]
        guard ctx.save() else { return false }
        self.animal = animal
        return true    }
    
    func canSave(name: String, sex: Animal.Sex, color: Animal.Color) -> Bool {
        return self.name != name || self.sex != sex || self.color != color
    }
    
    public func save(name: String, sex: Animal.Sex, color: Animal.Color) -> Bool {
        guard canSave(name: name, sex: sex, color: color) else { return false }
        guard let animal = self.animal else { return false }
        animal.name = name
        animal.wrappedSex = sex
        animal.wrappedColor = color
        guard ctx.save() else { return false }
        self.animal = animal
        return true    }
    
    public func remove() -> Bool {
        animal.map(ctx.container.viewContext.delete)
        guard ctx.save() else { return false }
        self.animal = animal
        return true
    }
    
    var color: Animal.Color {
        animal?.wrappedColor ?? Animal.Color.tabby_gray
    }
    
    var adoption: Adoption? {
        animal?.adoptionsArray.first
    }
    
    var displayName: String {
        (animal?.wrappedName ?? "Foo") + ((animal?.wrappedSex == .male ? "♂" : "♀") ?? "⚥")
    }
    
    var name: String {
        animal?.wrappedName ?? ""
    }
    
    var sex: Animal.Sex {
        animal?.wrappedSex ?? .male
    }
    
}
