
import Foundation

public extension String {
    
    
    //
    // Parse the ISO format string into NSDate.
    //
    // If the return value is nill, the string is not
    // a valid ISO format.
    //
    public func toISODate() -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // standard ISO date formate
        
        if !self.containsString(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // no nano second
            return dateFormatter.dateFromString(self);
        }
        
        return dateFormatter.dateFromString(self);
    }

}