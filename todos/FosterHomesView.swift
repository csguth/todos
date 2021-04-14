//
//  FosterHomesView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: FosterHome.entity(),
        sortDescriptors: []
    ) var fosterHomes: FetchedResults<FosterHome>
    
    @State var isSheetVisible = false
    
    var body: some View {
        ZStack {
            if fosterHomes.isEmpty {
                VStack {
                    Text("Sem LTs")
                    Button(action: {
                        isSheetVisible.toggle()
                    }, label: {
                        Text("Adicionar um!")
                    })
                }
            }
            else {
                List {
                    ForEach(fosterHomes) { home in
                        NavigationLink(
                            destination: FosterHomeDetailsView(for: home)
                                .environment(\.managedObjectContext, managedObjectContext),
                            label: {
                                Text(home.wrappedName)
                            })
                        
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.map{fosterHomes[$0]}.forEach{
                            managedObjectContext.delete($0)
                        }
                    })
                }
                .toolbar {
                    Button(action: {
                        isSheetVisible.toggle()
                    }, label: {
                        Image(systemName: "note.text.badge.plus")
                    })
                }
            }
        }
        .sheet(isPresented: $isSheetVisible) {
            AddFosterHomeView() { data in
                let newFosterHome = FosterHome(context: managedObjectContext)
                newFosterHome.id = UUID()
                newFosterHome.name = data.name
                newFosterHome.malesCount = data.maleCount
                newFosterHome.femalesCount = data.femaleCount
                newFosterHome.phone = data.phone
                newFosterHome.age = data.age
            }
        }
        .navigationBarTitle("Lares Temporários")
    }
}

struct FosterHomesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        FosterHomesView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
