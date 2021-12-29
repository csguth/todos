//
//  Animal.swift
//  todos
//
//  Created by Chrystian Guth on 25/04/2021.
//

import Foundation

extension Animal {
    
    enum Sex: String {
        case male = "M"
        case female = "F"
    }
    
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedSex: Sex {
        set {
            sex = newValue.rawValue
        }
        get {
            Sex(rawValue: sex ?? "M") ?? .male
        }
    }
    
    public var adoptionsArray: [Adoption] {
        let set = adoptions as? Set<Adoption> ?? []
        var output = [Adoption]()
//        output += set.filter{$0.isAlive && !$0.isReserved && !$0.isAdopted && !output.contains($0)}
//        output += set.filter{$0.isAlive && $0.isReserved && !output.contains($0)}
//        output += set.filter{$0.isAlive && $0.isAdopted && !output.contains($0)}
//        output += set.filter{!$0.isAlive && !output.contains($0)}
        output += set
        return output
    }

    var isAdopted: Bool {
//        if let wrappedAdoption = adoption {
//            return wrappedAdoption.date != nil
//        }
        return false
    }
    
    var isReserved: Bool {
//        if let wrappedAdoption = adoption {
//            return wrappedAdoption.date == nil
//        }
        return false
    }
    
    var isAlive: Bool {
        death == nil
    }
    
    var wrappedColor: String {
        color ?? ""
    }
    
}
