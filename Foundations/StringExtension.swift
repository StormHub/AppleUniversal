
import Foundation

//
// Provides String base extensions.
//
//
public extension String {

    /*
      Gets the character count of the string
    */
    public var length : Int {
        return self.characters.count
    }
    
    /*
      Gets the last index of the specified string
    */
    public func lastIndexOf(target: String) -> String.Index? {
        
        var range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch)
        var index : String.Index? = nil
        
        while range != nil {
            index = range!.startIndex
            
            let indexRange = Range(start: range!.endIndex, end: self.endIndex)
            range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: indexRange)
        }
        
        return index;
    }
    
    /*
    Splits words based on camel case.
    */
    public var split:String {
        var result = self
        result = result.stringByReplacingOccurrencesOfString("([a-z])([A-Z])", withString: "$1 $2", options: NSStringCompareOptions.RegularExpressionSearch, range: Range<String.Index>(start: result.startIndex, end: result.endIndex))
        result.replaceRange(result.startIndex...result.startIndex, with: String(result[result.startIndex]).capitalizedString)
        return result
    }
}