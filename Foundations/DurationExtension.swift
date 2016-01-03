
import Foundation


public extension Int64 {
    
    /*
       Converts a non negative integer to readable duration text.
       in year/month/day/hour/minute/second
    */
    public var durationSummary : String {
        if self <= 0 {
            return ""
        }
        
        let Minute:Int64 = 60
        let Hour = 60 * Minute
        let Day = 24 * Hour
        let Month = 30 * Day
        let Year = Day * 365

        let year = Int64(self / Year)
        if year > 0 {
            return year == 1
                ? "\(year) year"
                : "\(year) years"
        }
        
        let month = Int64(self / Month)
        if month > 0 {
            return month == 1
                ? "\(month) month"
                : "\(month) months"
        }
        
        let day = Int64(self / Day)
        if day > 0 {
            return day == 1
                ? "\(day) day"
                : "\(day) days"
        }
        
        let hour = Int64(self / Hour)
        if hour > 0 {
            return hour == 1
                ? "\(hour) hour"
                : "\(hour) hours"
        }
        
        let minute = Int64(self / Minute)
        if minute > 0 {
            return minute == 1
                ? "\(minute) minute"
                : "\(minute) minutes"
        }
        
        return self == 1
            ? "\(self) second"
            : "\(self) seconds"
    }
    
    /*
       Gets the duration in D.HH:MM:SS format
    */
    public var durationDescription : String {
        if self <= 0 {
            return ""
        }
     
        
        let Minute:Int64 = 60
        let Hour = 60 * Minute
        let Day = 24 * Hour

        var time = self
        let days = Int64(self / Day)
        if days > 0 {
            time -= Day * days
        }
        
        let hours = Int64(time / Hour)
        if hours > 0 {
            time -= hours * Hour
        }
        
        let minutes = Int64(time / Minute)
        if time > Minute {
            time -= minutes * Minute
        }
        
        var description = ""
        if days > 0 {
            description = "\(days)."
        }
        
        description += String(format: "%02d", hours) + ":"
        description += String(format: "%02d", minutes) + ":"
        description += String(format: "%02d", time)
        
        return description
      }
}