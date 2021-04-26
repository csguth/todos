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
    
    public var animalsArray: [Animal] {
        let set = animals as? Set<Animal> ?? []
        var output = [Animal]()
        output += set.filter{$0.isAlive && !$0.isReserved && !$0.isAdopted && !output.contains($0)}
        output += set.filter{$0.isAlive && $0.isReserved && !output.contains($0)}
        output += set.filter{$0.isAlive && $0.isAdopted && !output.contains($0)}
        output += set.filter{!$0.isAlive && !output.contains($0)}
        return output
    }
    
}
