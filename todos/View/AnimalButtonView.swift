//
//  AnimalButtonView.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import SwiftUI

struct AddAnimalButtonView: View {
    let onClicked: () -> Void
    
    var body: some View {
        Button(action: onClicked, label: {
            VStack {
                ZStack {
                    Rectangle()
                    .frame(width: 64, height: 64, alignment: .center)
                    .clipShape(Circle())
                        .foregroundColor(.gray)
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                Text("")
                    .font(.caption)
            }
            
        })
    }
}
