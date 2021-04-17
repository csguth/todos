//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

extension AddFosterHomeView {
    
    class ViewModel: ObservableObject, Identifiable {

        @Published var name: String = ""
        @Published var phone: String = ""
        @Published var maleCount: Int = 0
        @Published var femaleCount: Int = 0
        @Published var age: String = ""
                
        var canSave: Bool {
            !name.isEmpty && (Int(age) ?? 0) > 0
        }

        func reset() {
            name =  ""
            phone = ""
            maleCount = 0
            femaleCount = 0
            age = ""
        }
        
    }
    
}

struct AddFosterHomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var fosterHome: ViewModel
    
    let onSaved: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Perfil")) {
                TextField("Nome", text: $fosterHome.name)
                TextField("Telefone", text: $fosterHome.phone)
            }
            Section(header: Text("Gatos")) {

                Stepper(value: $fosterHome.maleCount, in: 0...10) {
                    Text("\(fosterHome.maleCount) machos")
                }
                Stepper(value: $fosterHome.femaleCount, in: 0...10) {
                    Text("\(fosterHome.femaleCount) fêmeas")
                }
                TextField("Idade em dias", text: $fosterHome.age)
                    .keyboardType(.numberPad)
            }
            Section {
                Button("Salvar", action: {
                    
                    let home = FosterHome(context: managedObjectContext)
                    home.id = UUID()
                    home.age = Int32(fosterHome.age) ?? 0
                    home.femalesCount = Int32(fosterHome.femaleCount)
                    home.malesCount = Int32(fosterHome.maleCount)
                    home.name = fosterHome.name
                    home.phone = fosterHome.phone
                    
                    try! managedObjectContext.save()
                    
                    fosterHome.reset()
                    
                    onSaved()
                })
                .disabled(!fosterHome.canSave)
            }
            
        }
        .navigationTitle("Novo Lt")
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.shared.container.viewContext
        let home = FosterHome(context: ctx)
        home.id = UUID()
        return AddFosterHomeView(fosterHome: AddFosterHomeView.ViewModel(), onSaved: {})
    }
}
