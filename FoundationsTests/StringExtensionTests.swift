

import XCTest

class StringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testLength() {
        XCTAssertEqual("".length, 0)
        XCTAssertEqual("1".length, 1)
        XCTAssertEqual("12".length, 2)
        XCTAssertEqual("123".length, 3)
    }
    
    func testLastIndexOfInvalid() {
        XCTAssertNil("".lastIndexOf(""))
        XCTAssertNil("".lastIndexOf("1"))
        XCTAssertNil("1".lastIndexOf("2"))
    }
    
    func testLastIndexOf() {
        let target = "SomeStringsomestring"
        let index = target.lastIndexOf("String")
        XCTAssertNotNil(index)
        XCTAssertEqual(index!, target.startIndex.advancedBy("Some".length))
        
        let index1 = target.lastIndexOf("string")
        XCTAssertNotNil(index1)
        XCTAssertEqual(index1!, target.startIndex.advancedBy("SomeStringsome".length))
        
        let index2 = target.lastIndexOf("S")
        XCTAssertNotNil(index2)
        XCTAssertEqual(index2!, target.startIndex.advancedBy("Some".length))
        
        let index3 = target.lastIndexOf("s")
        XCTAssertNotNil(index3)
        XCTAssertEqual(index3!, target.startIndex.advancedBy("SomeStringsome".length))
    }
}
