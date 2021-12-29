//
//  AnimalStore.swift
//  todos
//
//  Created by Chrystian Guth on 28/12/2021.
//

import Foundation
import SwiftUI

class AnimalStore: ObservableObject {
    @Published var animal: Animal?
    
    init(for animal: Animal) {
        _animal = Published(wrappedValue: animal)
    }
    
    public func rehome() {
        guard let animal = self.animal else {
            return
        }
        
        guard let firstAdoption = animal.adoptionsArray.first else {
            
            let adoption = Adoption(context: animal.managedObjectContext!)
            adoption.date = Date()
            adoption.name = "Foo"
            animal.addToAdoptions(adoption)
            try! animal.managedObjectContext?.save()
            self.animal = animal
            return
        }
        
        animal.removeFromAdoptions(firstAdoption)
        try! animal.managedObjectContext?.save()
        self.animal = animal
        
    }
    
    public func changeColor() {
        let colors = ["tabby-gray", "tabby-orange", "tuxedo"]
        guard let index = colors.firstIndex(of: color) else {
            return
        }
        animal?.color = colors[(index+1)%colors.count]
        try! animal?.managedObjectContext?.save()
        animal = self.animal
    }
    
    public func remove() {
        guard let animal = self.animal else {
            return
        }
        animal.managedObjectContext?.delete(animal)
    }
    
    var color: String {
        animal?.color ?? "tabby-gray"
    }
    
    var adoption: Adoption? {
        animal?.adoptionsArray.first
    }
    
    var displayName: String {
        guard let animal = self.animal else {
            return "Nil ☿"
        }
        return animal.wrappedName + (animal.wrappedSex == .male ? "♂" : "♀")
    }
    
}
