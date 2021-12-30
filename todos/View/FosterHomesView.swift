//
//  FosterHomesView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

struct FosterHomesView: View {
    
    @FetchRequest (
        entity: FosterHome.entity(),
        sortDescriptors: []
    ) var homes: FetchedResults<FosterHome>
    
    @EnvironmentObject var store: ApplicationStore
    @State var editing = false
    
    func create() {
        store.createFosterHome()
        editing = true
    }
    
    func delete(indexSet: IndexSet) {
        indexSet
            .map { homes[$0] }
            .forEach{ store.delete(fosterHome: $0) }
    }
    
    var body: some View {
        ZStack {
            if homes.isEmpty {
                VStack {
                    Text("Sem LTs")
                    Button("Adicionar!", action: create)
                }
            }
            else {
                List {
                    ForEach(homes) { home in
                        NavigationLink(
                            destination: FosterHomeDetailsView().environmentObject(store.storeFor(home: home)),
                            label: { Text(home.wrappedName) }
                        )
                    }
                    .onDelete(perform: delete)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: create, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
        .navigationBarTitle("Lares Temporários")
        .background(
            NavigationLink(destination: EditFosterHomeView().environmentObject(store), isActive: $editing) {
                EmptyView()
            }
        )
    }
}

struct FosterHomesView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
//        let persistenceController = PersistenceController.preview
//        FosterHomesView(fosterHomes: FosterHomesView.ViewModel(ctx: persistenceController.container.viewContext))
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
