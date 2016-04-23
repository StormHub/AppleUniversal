
import Foundation

public extension String {
    /*
     Parse the ISO format string into NSDate.
    
     If the return value is nill, the string is not
     a valid ISO format.
    */
    public func toISODate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // standard ISO date format
        
        var dateString = self
        
        // get rid of the time zone if any
        
        // UTC
        if dateString.hasSuffix("Z") {
            dateString = dateString.substringToIndex(dateString.endIndex.predecessor())
        } else {
            var index = self.lastIndexOf("+")
            if index == nil {
                index = self.lastIndexOf("-")
            }

            if index != nil {
                dateString = dateString.substringToIndex(index!)
            }
        }
        
        var lastPart : String? = nil
        
        // No nano seconds
        if dateString.containsString(".") {
            let tokens = dateString.componentsSeparatedByString(".")
            dateString = tokens[0]
            lastPart = tokens[1]
        }
        
        let dateValue = dateFormatter.dateFromString(dateString);
        if dateValue == nil
            || lastPart == nil {
            return dateValue
        }
        
        // only takes up to milliseconds
        if lastPart!.length > 3 {
            lastPart = lastPart!.substringWithRange(lastPart!.startIndex..<lastPart!.startIndex.advancedBy(3))
        }

        let nanoSecond = Int(lastPart!)
        if nanoSecond == nil {
            return dateValue
        }
        
        // get all components
        let components =  NSCalendar.currentAtUniversal.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Nanosecond], fromDate: dateValue!)
        components.nanosecond = nanoSecond!
        
        return NSCalendar.currentAtUniversal.dateFromComponents(components)
    }
    
}