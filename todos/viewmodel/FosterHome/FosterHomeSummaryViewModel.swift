//
//  FosterHomeSummaryViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation
import CoreData

extension FosterHomeSummaryView {
    class ViewModel: ObservableObject {
        @Published var fosterHome: FosterHome
        
        @Published var editFosterHome: FosterHomeEditView.ViewModel
        
        init (for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
            editFosterHome = FosterHomeEditView.ViewModel(with: fosterHome.managedObjectContext ?? PersistenceController.shared.container.viewContext)
            editFosterHome.reset(fosterHome: fosterHome)
        }
        
        private func makeText(_ text: String, for count: Int) -> String {
            let plural = count > 1 ? "s" : ""
            return count > 0 ? "\(count) \(text)\(plural)": ""
        }
        
        var malesCount: Int {
            Int(fosterHome.malesCount)
        }
        
        var femalesCount: Int {
            Int(fosterHome.femalesCount)
        }
        
        private var plus: String {
            malesCount > 0 && femalesCount > 0 ? " + " : ""
        }
        
        var text: String {
            return makeText("macho", for: malesCount) + plus + makeText("fêmea", for: femalesCount)
        }
        
    }
}
