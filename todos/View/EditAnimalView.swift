//
//  AnimalDetailsView.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import SwiftUI

struct EditAnimalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var animal: AnimalStore
    
    @State var name = String()
    @State var sex: Animal.Sex = .male
    @State var color: Animal.Color = .tabby_gray
    
    func nextColor() {
        color = color.next()
    }
    
    var canSave: Bool {
        animal.canSave(name: name, sex: sex, color: color)
    }
    
    func save() {
        guard animal.save(name: name, sex: sex, color: color) else { return }
        cancel()
    }
    
    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            Section(header: Text("Perfil")) {
                TextField("Nome", text: $name)
                .onAppear { name = animal.name }
                Picker(selection: $sex, label: Text("Sexo")) {
                    Text("Masculino").tag(Animal.Sex.male)
                    Text("Feminino").tag(Animal.Sex.female)
                }
                .onAppear { sex = animal.sex }
                .pickerStyle(.segmented)
            }
            Section(header: Text("Cor")) {
                Button(action: nextColor) {
                    Image(color.rawValue)
                    .onAppear { color = animal.color }
                }
            }
            Section {
                Button("Salvar", action: save).disabled(!canSave)
                Button("Cancelar", action: cancel)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Informações sobre o animal")
    }
    
}
