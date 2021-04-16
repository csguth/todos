//
//  TodoView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteView: View {
    
    @ObservedObject var note: Note
    
    let dateFormatter = DateFormatter()

    init(note: Note) {
        _note = ObservedObject(wrappedValue: note)
        dateFormatter.dateFormat = "dd/MM/yy hh:mm"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(dateFormatter.string(from: note.wrappedDate))
                .font(.subheadline)
            Text(note.wrappedContent)
                .padding()
        }

    }
}


struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let note = Note(context: persistenceController.container.viewContext)
        note.content = "the note content"
        return NoteView(note: note)
    }
}
