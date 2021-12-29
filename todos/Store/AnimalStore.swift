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
    @Published var animal: Animal
        
    init (animal: Animal) {
        _animal = Published(wrappedValue: animal)
    }

    private func adopt(who: String, ctx: NSManagedObjectContext) {
        let adoption = Adoption(context: ctx)
        adoption.date = Date()
        adoption.name = who
        animal.addToAdoptions(adoption)
        try! ctx.save()
        animal = self.animal
    }
    
    public func rehome() {
        guard let ctx = animal.managedObjectContext else {
            return
        }
        guard let firstAdoption = animal.adoptionsArray.first else {
            adopt(who: "Foo", ctx: ctx)
            return
        }
        animal.removeFromAdoptions(firstAdoption)
        try! ctx.save()
        animal = self.animal
    }
    
    public func changeColor() {
        let colors: [Animal.Color] = [.tabby_orange, .tabby_gray, .tuxedo]
        guard let index = colors.firstIndex(of: color) else {
            return
        }
        animal.wrappedColor = colors[(index+1)%colors.count]
        guard let ctx = animal.managedObjectContext else {
            return
        }
        try! ctx.save()
        animal = self.animal
    }
    
    public func save(name: String, sex: Animal.Sex, color: Animal.Color) {
        guard let ctx = animal.managedObjectContext else {
            return
        }
        animal.name = name
        animal.wrappedSex = sex
        animal.wrappedColor = color
        try! ctx.save()
        animal = self.animal
    }
    
    public func remove() {
        guard let ctx = animal.managedObjectContext else {
            return
        }
        ctx.delete(animal)
        try! ctx.save()
    }
    
    var color: Animal.Color {
        animal.wrappedColor
    }
    
    var adoption: Adoption? {
        animal.adoptionsArray.first
    }
    
    var displayName: String {
        animal.wrappedName + (animal.wrappedSex == .male ? "♂" : "♀")
    }
    
    var wrappedName: String {
        animal.wrappedName
    }
    
    var sex: Animal.Sex {
        animal.wrappedSex
    }
    
}
