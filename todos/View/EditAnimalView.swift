//
//  AnimalDetailsView.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation
import SwiftUI

struct EditAnimalView: View {
    
    @EnvironmentObject var animal: AnimalStore
    
    var body: some View {
        Text(animal.animal.wrappedName)
    }
    
}
