import XCTest

class NSDateExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testRelativeText() {
        let referenceTime = NSDate()
        
        let date1 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Second, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date1.relativeDescriptionTo(referenceTime), "one second ago")
        
        let date2 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Second, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date2.relativeDescriptionTo(referenceTime), "2 seconds ago")
        
        let date3 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Minute, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date3.relativeDescriptionTo(referenceTime), "a minute ago")
        
        let date4 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Minute, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date4.relativeDescriptionTo(referenceTime), "2 minutes ago")
        
        let date5 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Hour, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date5.relativeDescriptionTo(referenceTime), "an hour ago")
        
        let date6 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Hour, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date6.relativeDescriptionTo(referenceTime), "2 hours ago")
        
        let date7 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Day, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date7.relativeDescriptionTo(referenceTime), "yesterday")
        
        let date8 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Day, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date8.relativeDescriptionTo(referenceTime), "2 days ago")
        
        let date9 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Month, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date9.relativeDescriptionTo(referenceTime), "one month ago")
        
        let date10 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Month, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date10.relativeDescriptionTo(referenceTime), "2 months ago")
        
        let date11 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Year, value: -1, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date11.relativeDescriptionTo(referenceTime), "one year ago")
        
        let date12 = NSCalendar.currentAtUniversal.dateByAddingUnit(.Year, value: -2, toDate: referenceTime, options: NSCalendarOptions(rawValue: 0))!
        XCTAssertEqual(date12.relativeDescriptionTo(referenceTime), "2 years ago")
    }
}