
import Foundation

public extension Float {
    
    public func isCloseTo(x: Float) -> Bool {
        return Float.areClose(self, x)
    }
    
    public func between(x: Float, _ y: Float) -> Float {
        return clamp(self, x, y)
    }
    
    public static func areClose(a: Float, _ b: Float) -> Bool {
        // shortcut, handles infinities
        if a == b {
            return true
        }
        
        let absA = abs(a)
        let absB = abs(b)
        let diff = abs(a - b)
        
        if a == 0
            || b == 0
            || diff < FLT_MIN {
            
            // a or b is zero or both are extremely close to it
            // relative error is less meaningful here
            
            return diff < (FLT_EPSILON * FLT_MIN);
        }
        
        // use relative error
        return diff / (absA + absB) < FLT_EPSILON;
    }
}

public func clamp<T: Comparable>(x: T, _ a: T, _ b: T) -> T {
    let mininum = min(a, b)
    let maximum = max(a, b)
    
    if x < mininum {
        return mininum
    }
    
    if x > maximum {
        return maximum
    }
    
    return x
}
