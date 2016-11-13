
import Foundation

public extension String {
    /*
     Parse the ISO format string into NSDate.
    
     If the return value is nill, the string is not
     a valid ISO format.
    */
    public func toISODate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // standard ISO date format
        
        var dateString = self
        
        // get rid of the time zone if any
        
        // UTC
        if dateString.hasSuffix("Z") {
            dateString = dateString.substring(to: dateString.characters.index(before: dateString.endIndex))
        } else {
            var index = self.lastIndexOf("+")
            if index == nil {
                index = self.lastIndexOf("-")
            }

            if index != nil {
                dateString = dateString.substring(to: index!)
            }
        }
        
        var lastPart : String? = nil
        
        // No nano seconds
        if dateString.contains(".") {
            let tokens = dateString.components(separatedBy: ".")
            dateString = tokens[0]
            lastPart = tokens[1]
        }
        
        let dateValue = dateFormatter.date(from: dateString);
        if dateValue == nil
            || lastPart == nil {
            return dateValue
        }
        
        // only takes up to milliseconds
        if lastPart!.length > 3 {
            lastPart = lastPart!.substring(with: lastPart!.startIndex..<lastPart!.characters.index(lastPart!.startIndex, offsetBy: 3))
        }

        let nanoSecond = Int(lastPart!)
        if nanoSecond == nil {
            return dateValue
        }
        
        // get all components
        var components =  (Calendar.currentAtUniversal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: dateValue!)
        components.nanosecond = nanoSecond!
        
        return Calendar.currentAtUniversal.date(from: components)
    }
    
}
