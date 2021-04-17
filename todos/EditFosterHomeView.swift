//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

extension EditFosterHomeView {
    
    class ViewModel: ObservableObject, Identifiable {
        
        let managedObjectContext: NSManagedObjectContext

        @Published var name0: String = ""
        @Published var phone0: String = ""
        @Published var maleCount0: Int = 0
        @Published var femaleCount0: Int = 0
        @Published var age0: String = ""
        
        @Published var name: String = ""
        @Published var phone: String = ""
        @Published var maleCount: Int = 0
        @Published var femaleCount: Int = 0
        @Published var age: String = ""
        
        init (with ctx: NSManagedObjectContext) {
            managedObjectContext = ctx
            name = ""
            phone = ""
            maleCount = 0
            femaleCount = 0
            age = ""
            name0 = ""
            phone0 = ""
            maleCount0 = 0
            femaleCount0 = 0
            age0 = ""
        }
        
        init (from fosterHome: FosterHome) {
            managedObjectContext = fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            maleCount = Int(fosterHome.malesCount)
            femaleCount = Int(fosterHome.femalesCount)
            age = fosterHome.age == 0 ? "" : "\(fosterHome.age)"
            name0 = fosterHome.name ?? ""
            phone0 = fosterHome.phone ?? ""
            maleCount0 = Int(fosterHome.malesCount)
            femaleCount0 = Int(fosterHome.femalesCount)
            age0 = fosterHome.age == 0 ? "" : "\(fosterHome.age)"
        }
        
        var canSave: Bool {
            !name.isEmpty && (Int(age) ?? 0) > 0 && (name != name0 || phone != phone0 || maleCount != maleCount0 || femaleCount != femaleCount0 || age != age0)
        }
        
        func set(fosterHome: FosterHome) {
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            maleCount = Int(fosterHome.malesCount)
            femaleCount = Int(fosterHome.femalesCount)
            age = fosterHome.age == 0 ? "" : "\(fosterHome.age)"
            name0 = fosterHome.name ?? ""
            phone0 = fosterHome.phone ?? ""
            maleCount0 = Int(fosterHome.malesCount)
            femaleCount0 = Int(fosterHome.femalesCount)
            age0 = fosterHome.age == 0 ? "" : "\(fosterHome.age)"
        }
        
        func reset() {
            name = name0
            phone = phone0
            maleCount = maleCount0
            femaleCount = femaleCount0
            age = age0
        }
        
    }
    
}

struct EditFosterHomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var fosterHome: ViewModel
    
    let onSave: () -> Void
        
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
                    onSave()
                })
                .disabled(!fosterHome.canSave)
                Button("Cancelar", action: onSave)
            }
            
        }
        .navigationTitle("Configuração do Lt")
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: fosterHome.reset)
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.shared.container.viewContext
        let home = FosterHome(context: ctx)
        home.id = UUID()
        return EditFosterHomeView(fosterHome: EditFosterHomeView.ViewModel(from: home)) {
            
        }
    }
}
