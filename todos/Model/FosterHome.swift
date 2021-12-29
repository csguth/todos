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
    
    public var malesCount: Int {
        let set = animals as? Set<Animal> ?? []
        return set.filter{ $0.wrappedSex == .male }.count
    }
    
    public var femalesCount: Int {
        let set = animals as? Set<Animal> ?? []
        return set.filter{ $0.wrappedSex == .female }.count
    }
    
    private var animalsSet: Set<Animal> {
        animals as? Set<Animal> ?? []
    }
    
    public var animalsArray: [Animal] {
        animalsSet.sorted(by: { lhs, rhs in
            lhs.id < rhs.id
        })
    }
    
}
