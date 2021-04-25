//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct FosterHomeEditView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var fosterHome: ViewModel

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
                    fosterHome.save()
                    presentationMode.wrappedValue.dismiss()
                })
                .disabled(!fosterHome.canSave)
                Button("Cancelar", action: { presentationMode.wrappedValue.dismiss() })
            }
            
        }
        .navigationTitle("Configuração do Lt")
        .navigationBarBackButtonHidden(true)
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.shared.container.viewContext
        return FosterHomeEditView(fosterHome: FosterHomeEditView.ViewModel(with: ctx))
    }
}
