//
//  FosterHomeSummaryViewViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 20/04/2021.
//

import Foundation

extension FosterHomeSummaryView {
    class ViewModel: ObservableObject {
        @Published var fosterHome: FosterHome
        
        @Published var beingEdited: FosterHomeEditView.ViewModel
        
        init(for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
            beingEdited = FosterHomeEditView.ViewModel(from: fosterHome)
        }
        
        private func makeText(count: Int, text: String) -> String {
            let plural = count > 1 ? "s" : ""
            return count > 0 ? "\(count) \(text)\(plural)": ""
        }
        
        private var plus: String {
            fosterHome.malesCount > 0 && fosterHome.femalesCount > 0 ? " + " : ""
        }
        
        var text: String {
            return makeText(count: Int(fosterHome.malesCount), text: "macho") + plus + makeText(count: Int(fosterHome.femalesCount), text: "fêmea")
        }
        
    }
}
