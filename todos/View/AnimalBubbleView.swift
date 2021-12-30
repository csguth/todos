//
//  AnimalBubbleView.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import SwiftUI

struct AnimalBubbleView: View {
    @EnvironmentObject var animal: AnimalStore
    
    func rehome() {
        guard animal.rehome() else { return }
    }
    
    func remove() {
        guard animal.remove() else { return }
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: EditAnimalView().environmentObject(animal)
            ) {
                ZStack {
                    Image(animal.color.rawValue).resizable()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    animal.adoption.map { _ in
                        Image(systemName: "house.fill")
                            .opacity(0.70)
                    }
                }
                .foregroundColor(.white)
            }
            .contextMenu(ContextMenu(menuItems: {
                Button(action: rehome, label: {
                    Label("Rehome", systemImage: animal.adoption != nil ? "house.fill" : "house")
                })
                Button(action: remove, label: {
                    Label("Remove", systemImage: "trash.fill")
                })
            }))
            Text(animal.displayName).font(.caption)
        }
    }
}
