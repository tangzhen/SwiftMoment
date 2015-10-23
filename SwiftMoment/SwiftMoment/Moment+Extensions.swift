//
//  Moment+Extensions.swift
//  SwiftMoment
//
//  Created by Zhen Tang on 10/23/15.
//  Copyright © 2015 Adrian Kosmaczewski. All rights reserved.
//

import Foundation

/**
 Returns a moment representing the current instant in time
 at the current timezone.
 
 - returns: A Moment instance.
 */
public func moment(timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment {
        return Moment(timeZone: timeZone, locale: locale)
}

public func utc() -> Moment {
    let zone = NSTimeZone(abbreviation: "UTC")!
    return moment(zone)
}

extension Moment {
    init(dateString: String,
      formatString: String,
      locale: NSLocale = NSLocale.autoupdatingCurrentLocale(),
      strict: Bool = false) {
        self.date = NSDate()
        self.timeZone = NSTimeZone.defaultTimeZone()
        self.locale = locale
    }
}

/**
 Returns an Optional wrapping a Moment structure, representing the
 current instant in time. If the string passed as parameter cannot be
 parsed by the function, the Optional wraps a nil value.
 
 - parameter stringDate: A string with a date representation.
 - parameter timeZone:   An NSTimeZone object
 
 - returns: An optional Moment instance.
 */
public func moment(stringDate: String
    , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment? {
        let formatter = NSDateFormatter()
        formatter.timeZone = timeZone
        let isoFormat = "yyyy-MM-ddTHH:mm:ssZ"
        
        // The contents of the array below are borrowed
        // and adapted from the source code of Moment.js
        // https://github.com/moment/moment/blob/develop/moment.js
        let formats = [
            isoFormat,
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd",
            "h:mm:ss A",
            "h:mm A",
            "MM/dd/yyyy",
            "MMMM d, yyyy",
            "MMMM d, yyyy LT",
            "dddd, MMMM D, yyyy LT",
            "yyyyyy-MM-dd",
            "yyyy-MM-dd",
            "GGGG-[W]WW-E",
            "GGGG-[W]WW",
            "yyyy-ddd",
            "HH:mm:ss.SSSS",
            "HH:mm:ss",
            "HH:mm",
            "HH"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            
            if let date = formatter.dateFromString(stringDate) {
                return Moment(date: date, timeZone: timeZone, locale: locale)
            }
        }
        return nil
}

public func moment(stringDate: String
    , dateFormat: String
    , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        if let date = formatter.dateFromString(stringDate) {
            return Moment(date: date, timeZone: timeZone, locale: locale)
        }
        return nil
}

/**
 Builds a new Moment instance using an array with the following components,
 in the following order: [ year, month, day, hour, minute, second ]
 
 - parameter dateComponents: An array of integer values
 - parameter timeZone:   An NSTimeZone object
 
 - returns: An optional wrapping a Moment instance
 */
public func moment(params: [Int]
    , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment? {
        if params.count > 0 {
            let calendar = NSCalendar.currentCalendar()
            calendar.timeZone = timeZone
            let components = NSDateComponents()
            components.year = params[0]
            
            if params.count > 1 {
                components.month = params[1]
                if params.count > 2 {
                    components.day = params[2]
                    if params.count > 3 {
                        components.hour = params[3]
                        if params.count > 4 {
                            components.minute = params[4]
                            if params.count > 5 {
                                components.second = params[5]
                            }
                        }
                    }
                }
            }
            
            if let date = calendar.dateFromComponents(components) {
                return moment(date, timeZone: timeZone, locale: locale)
            }
        }
        return nil
}

public func moment(dict: [String: Int]
    , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment? {
        if dict.count > 0 {
            var params = [Int]()
            if let year = dict["year"] {
                params.append(year)
            }
            if let month = dict["month"] {
                params.append(month)
            }
            if let day = dict["day"] {
                params.append(day)
            }
            if let hour = dict["hour"] {
                params.append(hour)
            }
            if let minute = dict["minute"] {
                params.append(minute)
            }
            if let second = dict["second"] {
                params.append(second)
            }
            return moment(params, timeZone: timeZone, locale: locale)
        }
        return nil
}

public func moment(milliseconds: Int) -> Moment {
    return moment(NSTimeInterval(milliseconds / 1000))
}

public func moment(seconds: NSTimeInterval) -> Moment {
    let interval = NSTimeInterval(seconds)
    let date = NSDate(timeIntervalSince1970: interval)
    return Moment(date: date)
}

public func moment(date: NSDate
    , timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()
    , locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> Moment {
        return Moment(date: date, timeZone: timeZone, locale: locale)
}

public func moment(moment: Moment) -> Moment {
    let copy = moment.date.copy() as! NSDate
    let timeZone = moment.timeZone.copy() as! NSTimeZone
    let locale = moment.locale.copy() as! NSLocale
    return Moment(date: copy, timeZone: timeZone, locale: locale)
}