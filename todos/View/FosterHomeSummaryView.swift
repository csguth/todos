//
//  FosterHomeSummaryView.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

struct FosterHomeSummaryView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var fosterHome: ViewModel

    @State var editing = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    AddAnimalButtonView(onClicked: fosterHome.addAnimal)
                    ForEach(fosterHome.animalsArray) { animal in
                        AnimalBubbleView(animal: AnimalStore(for: animal))
                    }
                }
            }
            Text(fosterHome.text)
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
