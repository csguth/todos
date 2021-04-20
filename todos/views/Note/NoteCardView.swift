//
//  TodoView.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import SwiftUI

struct NoteCardView: View {
    
    let note: Note
    let dateFormatter = DateFormatter()

    init(for aNote: Note) {
        note = aNote
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
        return NoteCardView(for: note)
    }
}
