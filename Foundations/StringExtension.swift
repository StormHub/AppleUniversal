
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
   
}