//
//  NoteSheetView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteSheetView: View {
    @Environment(\.presentationMode) var presentationMode

    let dateFormatter = DateFormatter()
    let date = Date()
    @State var initialContent = ""
    @Binding var content: String
    let onSaved: (Date, String) -> Void

    init(content: Binding<String>, onSaved: @escaping (Date, String) -> Void) {
        dateFormatter.dateFormat = "dd/MM/yy"
        _content = content
        self.onSaved = onSaved
    }
    
    var body: some View {
        VStack {
            Text(dateFormatter.string(from: date))
            TextEditor(text: $content)
                .padding()
            HStack {
                Button("Save") {
                    onSaved(date, content)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .disabled(content.isEmpty || content == initialContent)
            }
        }
        .onAppear {
            initialContent = content
        }
    }
}

struct NoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSheetView(content: .constant("")) { _, _ in
            
        }
    }
}
