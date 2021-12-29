//
//  Date.swift
//  todos
//
//  Created by Chrystian Guth on 29/12/2021.
//

import Foundation

extension Date {
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    
    static var sevenDaysAgo: Date {
        Date().addingTimeInterval(-7 * 24 * 60 * 60)
    }
}
