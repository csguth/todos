//
//  FosterHome.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import Foundation

extension FosterHome {

    public var wrappedName: String{
        get{name ?? ""}
        set{name = newValue}
    }
    
    public var notesArray: [Note] {
        let set = notes as? Set<Note> ?? []
        return set.sorted {
            $0.date ?? Date() > $1.date ?? Date()
        }
    }
    
}
