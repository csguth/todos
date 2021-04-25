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
    
    var body: some View {
        HStack {
            Text(fosterHome.text)
            Spacer()
            NavigationLink(destination: FosterHomeEditView(fosterHome: fosterHome.editFosterHome)
            .environment(\.managedObjectContext, managedObjectContext)) {
                Text("Editar informações")
            }
        }.padding()
    }
}

struct FosterHomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.theId = UUID()
        fosterHome.femalesCount = 2
        fosterHome.malesCount = 1

        return FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel(for: fosterHome))
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
