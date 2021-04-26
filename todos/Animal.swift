//
//  Animal.swift
//  todos
//
//  Created by Chrystian Guth on 25/04/2021.
//

import Foundation
import SwiftUI

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
    

    var isAdopted: Bool {
        if let wrappedAdoption = adoption {
            return wrappedAdoption.date != nil
        }
        return false
    }
    
    var isReserved: Bool {
        if let wrappedAdoption = adoption {
            return wrappedAdoption.date == nil
        }
        return false
    }
    
    var isAlive: Bool {
        death == nil
    }
    
    var wrappedColor: String {
        color ?? ""
    }
    
    
    var photo: Image {
        Image(wrappedColor)
    }
}
