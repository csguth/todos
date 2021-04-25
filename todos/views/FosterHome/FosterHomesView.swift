//
//  FosterHomesView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

struct FosterHomesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest (
        entity: FosterHome.entity(),
        sortDescriptors: []
    ) var homes: FetchedResults<FosterHome>
    
    @StateObject var fosterHomes: ViewModel
    let dateFormatter: DateFormatter
    
    var body: some View {
        ZStack {
            if homes.isEmpty {
                VStack {
                    Text("Sem LTs")
                    Button("Adicionar!", action: fosterHomes.create)
                }
            }
            else {
                List {
                    ForEach(homes) { home in
                        NavigationLink(
                            destination: FosterHomeDetailsView(fosterHome: FosterHomeDetailsView.ViewModel(for: home, with: managedObjectContext, and: dateFormatter))
                                .environment(\.managedObjectContext, managedObjectContext),
                            label: {
                                Text(home.wrappedName)
                            })
                    }
                    .onDelete(perform: { indexSet in

                        let fosterHomes = indexSet.map{ homes[$0] }
                        fosterHomes.forEach(self.fosterHomes.deleteFosterHome)

                    })
                }

                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: fosterHomes.create, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
        .navigationBarTitle("Lares Temporários")
        .background(
            NavigationLink(destination: FosterHomeEditView(fosterHome: fosterHomes.editFosterHome)
            .environment(\.managedObjectContext, managedObjectContext),
                           isActive: $fosterHomes.isEditing) {
                EmptyView()
            }
        )
    }
}

struct FosterHomesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        FosterHomesView(fosterHomes: FosterHomesView.ViewModel(ctx: persistenceController.container.viewContext, and: DateFormatter()), dateFormatter: DateFormatter())
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
