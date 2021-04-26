//
//  FosterHomeSummaryView.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

struct AddAnimalButtonView: View {
    let onClicked: () -> Void
    
    var body: some View {
        Button(action: onClicked, label: {
            VStack {
                ZStack {
                    Rectangle()
                    .frame(width: 64, height: 64, alignment: .center)
                    .clipShape(Circle())
                        .foregroundColor(.gray)
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                Text("")
                    .font(.caption)
            }
            
        })
    }
}

struct FosterHomeSummaryView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var fosterHome: ViewModel

    @State var editing = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    AddAnimalButtonView(onClicked: fosterHome.addAnimal)
                    ForEach(fosterHome.animals) { animal in
                        AnimalBubbleView(animal: animal, onAdopted: { adopted in
                            
                            if adopted {
                                let adoption = animal.adoption != nil ? animal.adoption! : Adoption(context: managedObjectContext)
                                adoption.date = Date()
                                adoption.animal = animal
                                animal.adoption = adoption
                            } else {
                                if let adoption = animal.adoption {
                                    managedObjectContext.delete(adoption)
                                }
                                animal.adoption = nil
                            }
                            try! managedObjectContext.save()

                        }, onReserved: { reserved in
                            
                            if reserved {
                                let adoption = animal.adoption != nil ? animal.adoption! : Adoption(context: managedObjectContext)
                                adoption.date = nil
                                adoption.animal = animal
                                animal.adoption = adoption
                                
                            } else {
                                if let adoption = animal.adoption {
                                    managedObjectContext.delete(adoption)
                                }
                                animal.adoption = nil
                            }
                            
                            try! managedObjectContext.save()
                            
                        }, onDeceased: { deceased in
                            
                            animal.death = deceased ? Date() : nil
                            try! managedObjectContext.save()
                            
                        }, onRemoved: {
                            fosterHome.fosterHome.removeFromAnimals(animal)
                            managedObjectContext.delete(animal)
                            try! managedObjectContext.save()
                        })
                    }
                }
            }
            Text(fosterHome.text)
        }
//        VStack {
//            HStack {
//                Button("add", action: fosterHome.addAnimal)
//                ForEach(fosterHome.animals) { _ in
//                    Text("animal")
//                }
//                Text(fosterHome.text)
//                Spacer()
//
//                .environment(\.managedObjectContext, managedObjectContext),
//                isActive: $editing) {
//                    Text("Editar informações")
//                }
//            }.padding()
//        }
    }
}

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
        
        var animals: [Animal] {
            fosterHome.animalsArray
        }
        
        func addAnimal() {
            let ctx = fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext
            let animal = Animal(context: ctx)
            animal.fosterHome = fosterHome
            animal.color = "tabby-gray"
            animal.name = "Leona"
            animal.wrappedSex = .female
            fosterHome.addToAnimals(animal)
            
            try! ctx.save()
            
        }
        
    }
}

struct FosterHomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.id = UUID()
        
        let animal = Animal(context: persistenceController.container.viewContext)
        animal.fosterHome = fosterHome
        animal.color = "tabby-gray"
        animal.name = "Leona"
        animal.wrappedSex = .female

        return FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel(for: fosterHome))
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
