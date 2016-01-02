
import Foundation

public extension NSDate {
    
    // Gets the year of the NSDate in UTC
    public var year : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Year, fromDate: self)
    }
    
    // Gets the month of the NSDate in UTC
    public var  month : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Month, fromDate: self)
    }
    
    // Gets the day of the NSDate in UTC
    public var day : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Day, fromDate: self)
    }

    // Gets the hour of the NSDate in UTC
    public var hour : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Hour, fromDate: self)
    }
    
    // Gets the minute of the NSDate in UTC
    public var minute : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Minute, fromDate: self)
    }

    // Gets the minute of the NSDate in UTC
    public var second : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Second, fromDate: self)
    }
    
    // Gets the nano second of the NSDate in UTC
    public var nanoSecond : Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation:"UTC")!
        return calendar.component(NSCalendarUnit.Nanosecond, fromDate: self)
    }
}