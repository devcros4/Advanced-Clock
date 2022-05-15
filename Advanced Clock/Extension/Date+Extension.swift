//
//  Date+Extension.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 26/04/2022.
//

import Foundation

/*
 * -----------------------
 * MARK: - Calendar Stuff
 * ------------------------
 */
extension Date {
    private var calendar: Calendar {
        return Calendar.current
    }
    
    var weekDay: Int {
        return calendar.component(.weekday, from: self)
    }
    
    var weekOfonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    var year: Int {
        return calendar.component(.year, from: self)
    }
    
    var month: Int {
        return calendar.component(.month, from: self)
    }
    
    var quarter: Int {
        return calendar.component(.quarter, from: self)
    }
    
    var day: Int {
        return calendar.component(.day, from: self)
    }
    
    var era: Int {
        return calendar.component(.era, from: self)
    }
    
    var hours: Int {
        return calendar.component(.hour, from: self)
    }
    
    var minutes: Int {
        return calendar.component(.minute, from: self)
    }
    
    var seconds: Int {
        return calendar.component(.second, from: self)
    }
    
    var nanoseconds: Int {
        return calendar.component(.nanosecond, from: self)
    }
    
    var dayPart: String {
        switch self.hours {
        case 6..<12 :  return "Morning"
        case 12 : return "Noon"
        case 13..<17 : return "Afternoon"
        case 17..<22 : return "Evening"
        default: return "Night"
        }
    }
}


/*
 * -----------------------
 * MARK: - Utility
 * ------------------------
 */
extension Date {
    static var now: Date {
        return self.init()
    }
    
    var stringTime: String {
        return getStringTime()
    }
    
    var stringTimeWithSeconds: String {
        return getStringTime(showSeconds: true)
    }
    
    var timestamp: TimeInterval {
        return timeIntervalSince1970
    }
    
    private func getStringTime(showSeconds: Bool = false) -> String {
        var time = "\(hours.safeString):\(minutes.safeString)"
        
        if showSeconds {
            time += ":\(seconds.safeString)"
        }
        
        return time
    }
}
