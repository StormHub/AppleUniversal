import XCTest

class NSDateExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testRelativeText() {
        let referenceTime = Date()
        
        let date1 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .second, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date1.relativeDescriptionTo(referenceTime), "one second ago")
        
        let date2 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .second, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date2.relativeDescriptionTo(referenceTime), "2 seconds ago")
        
        let date3 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .minute, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date3.relativeDescriptionTo(referenceTime), "a minute ago")
        
        let date4 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .minute, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date4.relativeDescriptionTo(referenceTime), "2 minutes ago")
        
        let date5 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .hour, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date5.relativeDescriptionTo(referenceTime), "an hour ago")
        
        let date6 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .hour, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date6.relativeDescriptionTo(referenceTime), "2 hours ago")
        
        let date7 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .day, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date7.relativeDescriptionTo(referenceTime), "yesterday")
        
        let date8 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .day, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date8.relativeDescriptionTo(referenceTime), "2 days ago")
        
        let date9 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .month, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date9.relativeDescriptionTo(referenceTime), "one month ago")
        
        let date10 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .month, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date10.relativeDescriptionTo(referenceTime), "2 months ago")
        
        let date11 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .year, value: -1, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date11.relativeDescriptionTo(referenceTime), "one year ago")
        
        let date12 = (Calendar.currentAtUniversal as NSCalendar).date(byAdding: .year, value: -2, to: referenceTime, options: NSCalendar.Options(rawValue: 0))!
        XCTAssertEqual(date12.relativeDescriptionTo(referenceTime), "2 years ago")
    }
}
