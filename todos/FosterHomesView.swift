//
//  FosterHomesView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

extension FosterHomesView {
    
    class ViewModel: ObservableObject {
    
        @Environment(\.managedObjectContext) var managedObjectContext

        @FetchRequest (
            entity: FosterHome.entity(),
            sortDescriptors: []
        ) var fosterHomes: FetchedResults<FosterHome>
        
        private var selectedOne: FosterHome?
        let defaultFosterHome = FosterHome()
        
        @Published var isAdding = false
        
        var homes: [FosterHomeDetailsView.ViewModel] {
            fosterHomes.map {
                FosterHomeDetailsView.ViewModel(for: $0)
            }
        }
        
        func create() -> AddFosterHomeView.ViewModel {
            let newFosterHome = FosterHome(context: managedObjectContext)
            return AddFosterHomeView.ViewModel(for: newFosterHome)
        }
        
        var selected: FosterHome {
            selectedOne ?? FosterHome()
        }
    
        
        func add() {
            if isAdding {
                return
            }
            isAdding = true
        }
        
        func delete(indexSet: IndexSet) {
            indexSet.map {
                fosterHomes[$0]
            }
            .forEach(managedObjectContext.delete)
        }
        
        var isEmpty: Bool {
            fosterHomes.isEmpty
        }
        
    }
    
}

struct FosterHomesView: View {
    
    @ObservedObject var fosterHomes: ViewModel
    
    var body: some View {
        ZStack {
            if fosterHomes.isEmpty {
                VStack {
                    Text("Sem LTs")
                    Button(action: fosterHomes.add, label: {
                        Text("Adicionar um!")
                    })
                }
            }
            else {
                List {
                    ForEach(fosterHomes.homes) { home in
                        NavigationLink(
                            destination: FosterHomeDetailsView(fosterHome: home),
                            label: {
                                Text("")
                            })
                    }
                    .onDelete(perform: fosterHomes.delete)
                }
                .toolbar {
                    Button(action: fosterHomes.add, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
        }
        .sheet(isPresented: $fosterHomes.isAdding) {
            AddFosterHomeView(fosterHome: fosterHomes.create())
        }
        .navigationBarTitle("Lares Temporários")
    }
}

struct FosterHomesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        FosterHomesView(fosterHomes: FosterHomesView.ViewModel())
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
