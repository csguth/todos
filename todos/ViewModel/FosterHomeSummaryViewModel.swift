//
//  FosterHomeSummaryViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation

extension FosterHomeSummaryView {
    class ViewModel: ObservableObject {
        @Published var fosterHome: FosterHome
        
        @Published var beingEdited: EditFosterHomeView.ViewModel
        
        init(for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
            beingEdited = EditFosterHomeView.ViewModel(from: fosterHome)
        }
        
        private func makeText(count: Int, text: String) -> String {
            let plural = count > 1 ? "s" : ""
            return count > 0 ? "\(count) \(text)\(plural)": ""
        }
        
        private var plus: String {
            fosterHome.malesCount > 0 && fosterHome.femalesCount > 0 ? " + " : ""
        }
        
        var text: String {
            return makeText(count: Int(fosterHome.malesCount), text: "macho") + plus + makeText(count: Int(fosterHome.femalesCount), text: "fêmea")
        }
        
        var animalsArray: [Animal] {
            fosterHome.animalsArray
        }
        
        func addAnimal() {
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
}
