//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct AddedFosterHome {
    var name: String = ""
    var phone: String = ""
    var maleCount: Int32 = 0
    var femaleCount: Int32 = 0
    var ageString: String = ""
    var age: Int32 {
        Int32(ageString) ?? 0
    }
}

struct AddFosterHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var fosterHome = AddedFosterHome()
    
    let onSaved: (AddedFosterHome) -> Void

    init(onSaved: @escaping (AddedFosterHome) -> Void)
    {
        self.onSaved = onSaved
    }
    
    func save() {
        onSaved(fosterHome)
        presentationMode.wrappedValue.dismiss()

    }
    
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
                TextField("Idade em dias", text: $fosterHome.ageString)
                    .keyboardType(.numberPad)
            }
            Section {
                Button("Salvar", action: save)
                    .disabled(fosterHome.ageString.isEmpty || fosterHome.name.isEmpty)
            }
            
        }
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddFosterHomeView() { _ in
            
        }
    }
}
