//
//  Moment.swift
//  SwiftMoment
//
//  Created by Adrian on 19/01/15.
//  Copyright (c) 2015 Adrian Kosmaczewski. All rights reserved.
//

// Swift adaptation of Moment.js http://momentjs.com
// Github: https://github.com/moment/moment/

import Foundation

public func past() -> Moment {
    return Moment(date: NSDate.distantPast() )
}

public func future() -> Moment {
    return Moment(date: NSDate.distantFuture() )
}

public func since(past: Moment) -> Duration {
    return moment().intervalSince(past)
}

public func maximum(moments: Moment...) -> Moment? {
    if moments.count > 0 {
        var max: Moment = moments[0]
        for moment in moments {
            if moment > max {
                max = moment
            }
        }
        return max
    }
    return nil
}

public func minimum(moments: Moment...) -> Moment? {
    if moments.count > 0 {
        var min: Moment = moments[0]
        for moment in moments {
            if moment < min {
                min = moment
            }
        }
        return min
    }
    return nil
}

/**
 Internal structure used by the family of moment() functions.
 Instead of modifying the native NSDate class, this is a
 wrapper for the NSDate object. To get this wrapper object, simply
 call moment() with one of the supported input types.
*/
public struct Moment: Comparable {
    let date: NSDate
    let timeZone: NSTimeZone
    let locale: NSLocale

    init(date: NSDate = NSDate()
        , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
        , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) {
        self.date = date
        self.timeZone = timeZone
        self.locale = locale
    }

    /// Returns the year of the current instance.
    public var year: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Year, fromDate: date)
        return components.year
    }

    /// Returns the month (1-12) of the current instance.
    public var month: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Month, fromDate: date)
        return components.month
    }

    /// Returns the name of the month of the current instance, in the current locale.
    public var monthName: String {
        let formatter = NSDateFormatter()
        formatter.locale = locale
        return formatter.monthSymbols[month - 1] 
    }

    public var day: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Day, fromDate: date)
        return components.day
    }

    public var hour: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Hour, fromDate: date)
        return components.hour
    }

    public var minute: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Minute, fromDate: date)
        return components.minute
    }

    public var second: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Second, fromDate: date)
        return components.second
    }

    public var weekday: Int {
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = timeZone
        cal.locale = locale
        let components = cal.components(.Weekday, fromDate: date)
        return components.weekday
    }

    public var weekdayName: String {
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE"
        formatter.timeZone = timeZone
        return formatter.stringFromDate(date)
    }

    public var weekdayOrdinal: Int {
        let cal = NSCalendar.currentCalendar()
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.components(.WeekdayOrdinal, fromDate: date)
        return components.weekdayOrdinal
    }

    public var weekOfYear: Int {
        let cal = NSCalendar.currentCalendar()
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.components(.WeekOfYear, fromDate: date)
        return components.weekOfYear
    }

    public var quarter: Int {
        let cal = NSCalendar.currentCalendar()
        cal.locale = locale
        cal.timeZone = timeZone
        let components = cal.components(.Quarter, fromDate: date)
        return components.quarter
    }

    // Methods

    public func get(unit: TimeUnit) -> Int? {
        switch unit {
        case .Seconds:
            return second
        case .Minutes:
            return minute
        case .Hours:
            return hour
        case .Days:
            return day
        case .Months:
            return month
        case .Quarters:
            return quarter
        case .Years:
            return year
        }
    }

    public func get(unitName: String) -> Int? {
        if let unit = TimeUnit(rawValue: unitName) {
            return get(unit)
        }
        return nil
    }

    public func format(dateFormat: String = "yyyy-MM-dd HH:mm:SS ZZZZ") -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.stringFromDate(date)
    }

    public func isEqualTo(moment: Moment) -> Bool {
        return date.isEqualToDate(moment.date)
    }

    public func intervalSince(moment: Moment) -> Duration {
        let interval = date.timeIntervalSinceDate(moment.date)
        return Duration(value: interval)
    }

    public func add(value: Int, _ unit: TimeUnit) -> Moment {
        let components = NSDateComponents()
        switch unit {
        case .Years:
            components.year = value
        case .Quarters:
            components.month = 3 * value
        case .Months:
            components.month = value
        case .Days:
            components.day = value
        case .Hours:
            components.hour = value
        case .Minutes:
            components.minute = value
        case .Seconds:
            components.second = value
        }
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone(abbreviation: "UTC")!
        if let newDate = cal.dateByAddingComponents(components, toDate: date, options: NSCalendarOptions.init(rawValue: 0)) {
          return Moment(date: newDate)
        }
        return self
    }

    public func add(value: NSTimeInterval, _ unit: TimeUnit) -> Moment {
        let seconds = convert(value, unit)
        let interval = NSTimeInterval(seconds)
        let newDate = date.dateByAddingTimeInterval(interval)
        return Moment(date: newDate)
    }

    public func add(value: Int, _ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return add(value, unit)
        }
        return self
    }

    public func add(duration: Duration) -> Moment {
        return add(duration.interval, .Seconds)
    }

    public func subtract(value: NSTimeInterval, _ unit: TimeUnit) -> Moment {
        return add(-value, unit)
    }

    public func subtract(value: Int, _ unit: TimeUnit) -> Moment {
        return add(-value, unit)
    }

    public func subtract(value: Int, _ unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return subtract(value, unit)
        }
        return self
    }

    public func subtract(duration: Duration) -> Moment {
        return subtract(duration.interval, .Seconds)
    }

    public func isCloseTo(moment: Moment, precision: NSTimeInterval = 300) -> Bool {
        // "Being close" is measured using a precision argument
        // which is initialized a 300 seconds, or 5 minutes.
        let delta = intervalSince(moment)
        return abs(delta.interval) < precision
    }

    public func startOf(unit: TimeUnit) -> Moment {
        let cal = NSCalendar.currentCalendar()
        var newDate: NSDate?
        let components = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        switch unit {
        case .Seconds:
            return self
        case .Years:
            components.month = 1
            fallthrough
        case .Quarters, .Months:
            components.day = 1
            fallthrough
        case .Days:
            components.hour = 0
            fallthrough
        case .Hours:
            components.minute = 0
            fallthrough
        case .Minutes:
            components.second = 0
        }
        newDate = cal.dateFromComponents(components)
        return newDate == nil ? self : Moment(date: newDate!)
    }

    public func startOf(unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return startOf(unit)
        }
        return self
    }

    public func endOf(unit: TimeUnit) -> Moment {
        return startOf(unit).add(1, unit).subtract(1.seconds)
    }

    public func endOf(unitName: String) -> Moment {
        if let unit = TimeUnit(rawValue: unitName) {
            return endOf(unit)
        }
        return self
    }

    public func epoch() -> NSTimeInterval {
        return date.timeIntervalSince1970
    }

    // Private methods

    func convert(value: Double, _ unit: TimeUnit) -> Double {
        switch unit {
        case .Seconds:
            return value
        case .Minutes:
            return value * 60
        case .Hours:
            return value * 3600 // 60 minutes
        case .Days:
            return value * 86400 // 24 hours
        case .Months:
            return value * 2592000 // 30 days
        case .Quarters:
            return value * 7776000 // 3 months
        case .Years:
            return value * 31536000 // 365 days
        }
    }
}

extension Moment: CustomStringConvertible {
    public var description: String {
        return format()
    }
}

extension Moment: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

