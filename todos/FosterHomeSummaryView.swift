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
        HStack {
            Text(fosterHome.text)
            Spacer()
            NavigationLink(destination: EditFosterHomeView(fosterHome: fosterHome.beingEdited, onSave: {
                editing = false
            })
            .onAppear{
                fosterHome.beingEdited.set(fosterHome: fosterHome.fosterHome)
            }
            .environment(\.managedObjectContext, managedObjectContext),
            isActive: $editing) {
                Text("Editar informações")
            }
        }.padding()
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
        
    }
}

struct FosterHomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.id = UUID()
        fosterHome.femalesCount = 2
        fosterHome.malesCount = 1

        return FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel(for: fosterHome))
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
