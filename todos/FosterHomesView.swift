//
//  FosterHomesView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

extension FosterHomesView {
    class ViewModel: ObservableObject {
        
        @Published var fosterHomeBeingEdited: EditFosterHomeView.ViewModel
        @Published var isEditing = false
        
        init(ctx: NSManagedObjectContext) {
            fosterHomeBeingEdited = EditFosterHomeView.ViewModel(with: ctx)
        }
        
        func create() {
            if isEditing {
                return
            }
            fosterHomeBeingEdited.reset()
            isEditing = true
        }
    }
}

struct FosterHomesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest (
        entity: FosterHome.entity(),
        sortDescriptors: []
    ) var homes: FetchedResults<FosterHome>
    
    @StateObject var fosterHomes: ViewModel
    
    private func deleteFosterHome(fosterHome: FosterHome) {
        managedObjectContext.delete(fosterHome)
        try! managedObjectContext.save()
    }
    
    private func toggleEditing() {
        fosterHomes.isEditing.toggle()
    }
        
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
                            destination: FosterHomeDetailsView(fosterHome: FosterHomeDetailsView.ViewModel(for: home))
                                .environment(\.managedObjectContext, managedObjectContext),
                            label: {
                                Text(home.wrappedName)
                            })
                    }
                    .onDelete(perform: { $0.map{ homes[$0] }.forEach(deleteFosterHome)})
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
            NavigationLink(destination: EditFosterHomeView(fosterHome: fosterHomes.fosterHomeBeingEdited, onSave: toggleEditing)
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
        FosterHomesView(fosterHomes: FosterHomesView.ViewModel(ctx: persistenceController.container.viewContext))
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
