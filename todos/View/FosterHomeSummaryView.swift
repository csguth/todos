//
//  FosterHomeSummaryView.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

struct FosterHomeSummaryView: View {
    
    @EnvironmentObject var fosterHome: FosterHomeStore
    
    private func makeText(count: Int, text: String) -> String {
        let plural = count > 1 ? "s" : ""
        return count > 0 ? "\(count) \(text)\(plural)": ""
    }
    
    private var plus: String {
        fosterHome.malesCount > 0 && fosterHome.femalesCount > 0 ? " + " : ""
    }

    private var text: String {
        return makeText(count: Int(fosterHome.malesCount), text: "macho") + plus + makeText(count: Int(fosterHome.femalesCount), text: "fêmea")
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    AddAnimalButtonView(onClicked: fosterHome.createAnimal)
                    ForEach(fosterHome.animals) { AnimalBubbleView().environmentObject($0) }
                }
            }
            Text(text)
        }
    }
}

struct FosterHomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
//        let persistenceController = PersistenceController.preview
//
//        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
//        fosterHome.id = UUID()
//
//        let animal = Animal(context: persistenceController.container.viewContext)
//        animal.fosterHome = fosterHome
//        animal.color = "tabby-gray"
//        animal.name = "Leona"
//        animal.wrappedSex = .female
//
//        return FosterHomeSummaryView()
//            .environmentObject(FosterHomeStore(for: fosterHome))
    }
}
