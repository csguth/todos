//
//  FosterHomeSummaryView.swift
//  todos
//
//  Created by Chrystian Guth on 14/04/2021.
//

import SwiftUI

struct FosterHomeSummaryView: View {
    
    @ObservedObject var fosterHome: ViewModel

    var body: some View {
        return Text(fosterHome.text)
    }
}

extension FosterHomeSummaryView {
    class ViewModel: ObservableObject {
        @Published var fosterHome: FosterHome
        
        init(for fosterHome: FosterHome) {
            _fosterHome = Published(wrappedValue: fosterHome)
        }
        
        private func makeText(count: Int, letter: Character) -> String {
            count > 0 ? "\(count)\(letter)": ""
        }
        
        private var plus: String {
            fosterHome.malesCount > 0 && fosterHome.femalesCount > 0 ? "+ " : ""
        }
        
        var text: String {
            return makeText(count: Int(fosterHome.malesCount), letter: "M") + plus + makeText(count: Int(fosterHome.femalesCount), letter: "F")
        }
        
    }
}

struct FosterHomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        let fosterHome = FosterHome(context: persistenceController.container.viewContext)
        fosterHome.id = UUID()
        fosterHome.femalesCount = 2
        fosterHome.malesCount = 1

        return Text("")
//        return FosterHomeSummaryView(fosterHome: FosterHomeSummaryView.ViewModel)
//        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
