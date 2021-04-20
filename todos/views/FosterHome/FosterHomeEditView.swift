//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeEditView: View {
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
                DatePicker(
                    "Nascimento (\(fosterHome.age))",
                    selection: $fosterHome.date,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
            }
            Section {
                Button("Salvar", action: {
                    if fosterHome.home == nil {
                        let home = FosterHome(context: managedObjectContext)
                        home.id = UUID()
                        self.fosterHome.home = home
                    }
                    let home = self.fosterHome.home!
                    home.date = fosterHome.date
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
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.shared.container.viewContext
        let home = FosterHome(context: ctx)
        home.id = UUID()
        return FosterHomeEditView(fosterHome: FosterHomeEditView.ViewModel(from: home)) {
            
        }
    }
}
