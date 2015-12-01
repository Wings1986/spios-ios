//
//  NSDateExtension.swift
//  spios
//
//  Created by Administrator on 6/12/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//
// Convert NSDate to String for discussion pages (e.g Just now, 1 min ago, 2 hours ago)

import UIKit

extension NSDate {

    func yearsFrom(date:NSDate)   -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year }
    func monthsFrom(date:NSDate)  -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month }
    func weeksFrom(date:NSDate)   -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear }
    func daysFrom(date:NSDate)    -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day }
    func hoursFrom(date:NSDate)   -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour }
    func minutesFrom(date:NSDate) -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute }
    func secondsFrom(date:NSDate) -> Int { return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second }
    var relativeTime: String {
        if NSDate().yearsFrom(self)  > 0 {
            return NSDate().yearsFrom(self).description  + " year"  + { return NSDate().yearsFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().monthsFrom(self) > 0 {
            return NSDate().monthsFrom(self).description + " month" + { return NSDate().monthsFrom(self)  > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().weeksFrom(self)  > 0 { return NSDate().weeksFrom(self).description  + " week"  + { return NSDate().weeksFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().daysFrom(self)   > 0 {
            if daysFrom(self) == 1 { return "Yesterday" }
            return NSDate().daysFrom(self).description + " day" + { return NSDate().daysFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().hoursFrom(self)   > 0 {
            return "\(NSDate().hoursFrom(self)) hour"     + { return NSDate().hoursFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().minutesFrom(self) > 0 {
            return "\(NSDate().minutesFrom(self)) min" + { return NSDate().minutesFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if NSDate().secondsFrom(self) > 0 {
            if NSDate().secondsFrom(self) < 15 { return "Just now"  }
            return "\(NSDate().secondsFrom(self)) sec" + { return NSDate().secondsFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
    
    var stringDate: String {

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, hh:mm a" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(self)
        return dateString
    }

}
