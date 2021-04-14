//
//  TodoData.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//

import Foundation

extension Note {

    public var wrappedDate: Date {
        get{date ?? Date()}
        set{date = newValue}
    }
    
    public var wrappedContent: String{
        get{content ?? ""}
        set{content = newValue}
    }
}
