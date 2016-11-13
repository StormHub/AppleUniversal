
import Foundation

public extension Date {

    /* 
        Get the time description in English relative to now
    */
    public var relativeDescription : String {
        return self.relativeDescriptionTo(Date())
    }
    
    internal func relativeDescriptionTo(_ relativeTo: Date) -> String {
        let target = relativeTo.timeIntervalSince1970
        let current = self.timeIntervalSince1970
        
        // get rid of the nanosecond part
        let delta = Int64(current.distance(to: target))
        if delta <= 0 {
            // either the time is exactly the same
            // or reference time is later than this time
            return ""
        }
        
        let Minute:Int64 = 60
        if delta < Minute {
            return delta == 1
                ? "one second ago"
                : "\(delta) seconds ago"
        }
        
        if delta < 2 * Minute {
            return "a minute ago"
        }
        
        if delta < 45 * Minute {
            let minute = Int64(delta / Minute)
            return "\(minute) minutes ago"
        }
        
        if delta < 90 * Minute {
            return "an hour ago"
        }
        
        let Hour = 60 * Minute
        if delta < 24 * Hour  {
            let hour = Int64(delta / Hour)
            return "\(hour) hours ago"
        }
        
        if delta < 48 * Hour {
            return "yesterday"
        }
        
        let Day = 24 * Hour
        let day = Int64(delta / Day)
        
        if delta < 30 * Day {
            return "\(day) days ago"
        }
        
        let Month = 30 * Day
        if delta < 12 * Month {
            let month = Int64(delta / Month)
            return month <= 1
                ? "one month ago"
                : "\(month) months ago"
        }
        
        let year = Int64(day / 365)
        return year <= 1
            ? "one year ago"
            : "\(year) years ago"
    }
    
    /*
       Gets the year of the NSDate in UTC
     */
    public var year : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.year, from: self)
    }
    
    /*
       Gets the month of the NSDate in UTC
     */
    public var  month : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.month, from: self)
    }
    
    /*
       Gets the day of the NSDate in UTC
     */
    public var day : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.day, from: self)
    }

    /*
      Gets the hour of the NSDate in UTC
    */
    public var hour : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.hour, from: self)
    }
    
    /*
       Gets the minute of the NSDate in UTC
     */
    public var minute : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.minute, from: self)
    }

    /*
       Gets the minute of the NSDate in UTC
     */
    public var second : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.second, from: self)
    }
    
    /*
       Gets the nano second of the NSDate in UTC
     */
    public var nanoSecond : Int {
        return (Calendar.currentAtUniversal as NSCalendar).component(NSCalendar.Unit.nanosecond, from: self)
    }
    
    /*
    Formats the date in medium style.
    */
    public var mediumStyle: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: self)
    }
}

public extension Calendar {
    
    /*
       Gets the current calendar at universal time zone
    */
    public static var currentAtUniversal : Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation:"UTC")!

        return calendar
    }
}
