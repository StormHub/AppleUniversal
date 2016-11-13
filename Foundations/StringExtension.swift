
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
    public func lastIndexOf(_ target: String) -> String.Index? {
        
        var range = self.range(of: target, options: NSString.CompareOptions.literal)
        var index : String.Index? = nil
        
        while range != nil {
            index = range!.lowerBound
            
            let indexRange = range!.upperBound..<self.endIndex
            range = self.range(of: target, options: NSString.CompareOptions.literal, range: indexRange)
        }
        
        return index;
    }
    
    /*
    Splits words based on camel case.
    */
    public var split:String {
        var result = self
        let range = self.characters.startIndex..<self.characters.endIndex
        result = result.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: NSString.CompareOptions.regularExpression, range:range)
        result.replaceSubrange(result.startIndex...result.startIndex, with: String(result[result.startIndex]).capitalized)
        return result
    }
}
