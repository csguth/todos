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
    
    @State var isAdding = false
    
    var body: some View {
        ZStack {
            if homes.isEmpty {
                VStack {
                    Text("Sem LTs")
                    Button(action: {
                        isAdding.toggle()
                    }, label: {
                        Text("Adicionar")
                    })
                }
            }
            else {
                List {
                    ForEach(homes) { home in
                        NavigationLink(
                            destination: FosterHomeDetailsView(fosterHome: FosterHomeDetailsView.ViewModel(for: home))
                                .environment(\.managedObjectContext, managedObjectContext),
                            label: {
                                Text(home.wrappedName)
                            })
                    }
                    .onDelete(perform: { indexSet in
                        indexSet
                            .map { homes[$0] }
                            .forEach(managedObjectContext.delete)
                        try? managedObjectContext.save()
                    })
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isAdding.toggle() }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
        .navigationBarTitle("Lares Temporários")
        .background(
            NavigationLink(destination: AddFosterHomeView(fosterHome: AddFosterHomeView.ViewModel())  {
                isAdding = false
            }
            .environment(\.managedObjectContext, managedObjectContext),
            isActive: $isAdding) {
                EmptyView()
            }
        )
    }
}

struct FosterHomesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        FosterHomesView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
