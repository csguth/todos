//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

struct EditFosterHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: ApplicationStore

    @State var name = String()
    @State var phone = String()
    @State var date = Date()
    
    var canSave: Bool {
        store.canSave(name: name, phone: phone, date: date)
    }
    
    func save() {
        if store.save(name: name, phone: phone, date: date) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func cancel() {
        store.cancel()
        presentationMode.wrappedValue.dismiss()
    }
    
    var age: String {
        let days = date.daysBetween(date: Date())
        let plural = days > 1 ? "s" : ""
        return "\(days) dia\(plural)"
    }
    
    var currentName: String {
        store.currentFosterHome?.name ?? ""
    }
    
    var currentPhone: String {
        store.currentFosterHome?.phone ?? ""
    }
    
    var currentDate: Date {
        store.currentDate
    }
            
    var body: some View {
        Form {
            Section(header: Text("Perfil")) {
                TextField("Nome", text: $name)
                TextField("Telefone", text: $phone)
            }
            Section(header: Text("Gatos")) {
                DatePicker(
                    "Nascimento (\(age))",
                    selection: $date,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
            }
            Section {
                Button("Salvar", action: save).disabled(!canSave)
                Button("Cancelar", action: cancel)
            }
            
        }
        .navigationTitle("Configuração do Lt")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            name = currentName
            phone = currentPhone
            date = currentDate
        }
    }

}

struct AddFosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceController.preview
        let home = FosterHome(context: ctx.container.viewContext)
        home.id = UUID()
        home.name = "Lar da Leoninha"
        home.phone = "phone"
        let store = ApplicationStore(with: ctx)
        store.edit(fosterHome: home)
        return EditFosterHomeView()
            .environmentObject(store)
    }
}
