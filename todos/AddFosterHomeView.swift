//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

extension AddFosterHomeView {
    
    class ViewModel: ObservableObject, Identifiable {
                
        @Published  var home: FosterHome?
        var name: String
        var phone: String
        var maleCount: Int
        var femaleCount: Int
        var age: String
        
        init (for fosterHome: FosterHome?) {
            home = fosterHome
            name = fosterHome?.name ?? ""
            phone = fosterHome?.phone ?? ""
            maleCount = Int(fosterHome?.malesCount ?? 0)
            femaleCount = Int(fosterHome?.femalesCount ?? 0)
            age = "\(fosterHome?.age ?? 0)"
        }
        
        var id: UUID {
            home?.id ?? UUID()
        }
        
        func save() {
            guard let age = Int32(self.age) else {
                return
            }
            home?.name = name
            home?.phone = phone
            home?.malesCount = Int32(maleCount)
            home?.femalesCount = Int32(maleCount)
            home?.age = age
            try? home?.managedObjectContext?.save()
        }
        
        
    }
    
}

struct ViewModel {
    
}

struct AddFosterHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var fosterHome: ViewModel
    
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
                Button("Salvar", action: fosterHome.save)
                    .disabled(fosterHome.age.isEmpty || fosterHome.name.isEmpty)
            }
            
        }
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddFosterHomeView(fosterHome: AddFosterHomeView.ViewModel(for: nil))
    }
}
