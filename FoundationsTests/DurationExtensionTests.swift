import XCTest

class DurationExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testdurationDescriptionInvalid() {
        var value = Int64(0)
        XCTAssertEqual(value.durationDescription, "")
        
        value = Int64(-1)
        XCTAssertEqual(value.durationDescription, "")
    }
    
    func testDurationDescription() {
        var value = Int64(1)
        XCTAssertEqual(value.durationDescription, "00:00:01")
        
        value = Int64(60 + 1)
        XCTAssertEqual(value.durationDescription, "00:01:01")
        
        value = Int64(60 * 60 + 60 + 1)
        XCTAssertEqual(value.durationDescription, "01:01:01")
        
        value = Int64(60 * 60 * 24 + 60 * 60 + 60 + 1)
        XCTAssertEqual(value.durationDescription, "1.01:01:01")
    }
    
    func testdurationSummaryInvalid() {
        var value = Int64(0)
        XCTAssertEqual(value.durationSummary, "")
        
        value = Int64(-1)
        XCTAssertEqual(value.durationSummary, "")
    }
    
    func testdurationSummary() {
        var value = Int64(1)
        XCTAssertEqual(value.durationSummary, "1 second")
        
        value = Int64(2)
        XCTAssertEqual(value.durationSummary, "2 seconds")
        
        value = Int64(60)
        XCTAssertEqual(value.durationSummary, "1 minute")
        
        value = Int64(70)
        XCTAssertEqual(value.durationSummary, "1 minute")
        
        value = Int64(60 * 5)
        XCTAssertEqual(value.durationSummary, "5 minutes")
        
        value = Int64(60 * 60)
        XCTAssertEqual(value.durationSummary, "1 hour")
        
        value = Int64(60 * 60 + 20)
        XCTAssertEqual(value.durationSummary, "1 hour")
        
        value = Int64(60 * 60 * 2)
        XCTAssertEqual(value.durationSummary, "2 hours")
        
        value = Int64(60 * 60 * 24)
        XCTAssertEqual(value.durationSummary, "1 day")
        
        value = Int64(60 * 60 * 24 + 60 * 60 * 10)
        XCTAssertEqual(value.durationSummary, "1 day")
        
        value = Int64(60 * 60 * 24 * 3)
        XCTAssertEqual(value.durationSummary, "3 days")
        
        value = Int64(60 * 60 * 24 * 30)
        XCTAssertEqual(value.durationSummary, "1 month")
        
        value = Int64(60 * 60 * 24 * 30 + 60 * 60 * 24 * 10)
        XCTAssertEqual(value.durationSummary, "1 month")
        
        value = Int64(60 * 60 * 24 * 30 * 2)
        XCTAssertEqual(value.durationSummary, "2 months")
        
        value = Int64(60 * 60 * 24 * 365)
        XCTAssertEqual(value.durationSummary, "1 year")
        
        value = Int64(60 * 60 * 24 * 365 + 60 * 60 * 24 * 100)
        XCTAssertEqual(value.durationSummary, "1 year")
        
        value = Int64(60 * 60 * 24 * 365 * 10)
        XCTAssertEqual(value.durationSummary, "10 years")
    }
}