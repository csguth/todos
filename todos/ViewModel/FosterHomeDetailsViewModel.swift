//
//  FosterHomeDetailsViewModel.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

extension FosterHomeDetailsView {
    
    class ViewModel: ObservableObject, Identifiable {
        @Published var fosterHome: FosterHome?
        
        init (for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
        }
        
        var id: UUID {
            fosterHome?.id ?? UUID()
        }
        
        var name: String {
            fosterHome?.wrappedName ?? ""
        }
        
        var notesArray: [Note] {
            fosterHome?.notesArray ?? [Note]()
        }

    }
    

}
