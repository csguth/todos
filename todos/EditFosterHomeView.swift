//
//  AddFosterHomeView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI
import CoreData

extension Date {
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    
    static var sevenDaysAgo: Date {
        Date().addingTimeInterval(-7 * 24 * 60 * 60)
    }
}

extension EditFosterHomeView {
    
    class ViewModel: ObservableObject, Identifiable {
        
        var home: FosterHome?
        let managedObjectContext: NSManagedObjectContext
        
        @Published var name: String
        @Published var phone: String
        @Published var maleCount: Int
        @Published var femaleCount: Int
        @Published var date: Date
        
        init (with ctx: NSManagedObjectContext) {
            home = nil
            managedObjectContext = ctx
            name = ""
            phone = ""
            maleCount = 0
            femaleCount = 0
            date = Date.sevenDaysAgo
        }
        
        var ageInDays: String {
            let date = home?.date ?? Date()
            let daysCount = date.daysBetween(date: Date())
            return daysCount == 0 ? "" : "\(daysCount)"
        }
        
        init (from fosterHome: FosterHome) {
            home = fosterHome
            managedObjectContext = fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            maleCount = Int(fosterHome.malesCount)
            femaleCount = Int(fosterHome.femalesCount)
            date = fosterHome.date ?? Date.sevenDaysAgo
        }
        
        var canSave: Bool {
            return (!name.isEmpty && date.daysBetween(date: Date()) > 0) && ((name != home?.name) || (phone != home?.phone) || (maleCount != Int(home?.malesCount ?? 0)) || (femaleCount != Int(home?.femalesCount ?? 0)) || (date != home?.date))
        }
        
        var age: String {
            let days = date.daysBetween(date: Date())
            let plural = days > 1 ? "s" : ""
            return "\(days) dia\(plural)"
        }
        
        func set(fosterHome: FosterHome) {
            home = fosterHome
            name = fosterHome.name ?? ""
            phone = fosterHome.phone ?? ""
            maleCount = Int(fosterHome.malesCount)
            femaleCount = Int(fosterHome.femalesCount)
            date = fosterHome.date ?? Date.sevenDaysAgo
        }
        
        func reset() {
            home = nil
            name = home?.name ?? ""
            phone = home?.phone ?? ""
            maleCount = Int(home?.malesCount ?? 0)
            femaleCount = Int(home?.femalesCount ?? 0)
            date = home?.date ?? Date.sevenDaysAgo
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
