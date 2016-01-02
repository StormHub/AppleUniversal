//
//  FoundationsTests.swift
//  FoundationsTests
//
//  Created by Johnny Chow on 1/01/2016.
//  Copyright © 2016 Foundations. All rights reserved.
//

import XCTest

class StringToNSDateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testToISODateInvalid() {
        let date = "".toISODate()
        XCTAssertNil(date)
    
        let date1 = "N".toISODate()
        XCTAssertNil(date1)

        let date2 = "2016".toISODate()
        XCTAssertNil(date2)
    }
    
    func testToISODateStandard() {
        let date = "2015-11-01T10:20:03Z".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2015)
        XCTAssertEqual(target.month, 11)
        XCTAssertEqual(target.day, 1)
        XCTAssertEqual(target.hour, 10)
        XCTAssertEqual(target.minute, 20)
        XCTAssertEqual(target.second, 3)
        XCTAssertEqual(target.nanoSecond, 0)
    }
    
    func testToISODateWithNanosecond() {
        let date = "2016-01-03T01:02:03.456789Z".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2016)
        XCTAssertEqual(target.month, 1)
        XCTAssertEqual(target.day, 3)
        XCTAssertEqual(target.hour, 1)
        XCTAssertEqual(target.minute, 2)
        XCTAssertEqual(target.second, 3)
        
        /*
         We only ensure nanoseconds are greater than zero
         because the nanoseond precision changes
        */
        XCTAssertGreaterThan(target.nanoSecond, 0)
    }
    
    func testToISODateWithTimeZoneAdd() {
        let date = "2015-12-24T08:17:55.6354152+10:00".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2015)
        XCTAssertEqual(target.month, 12)
        XCTAssertEqual(target.day, 24)
        XCTAssertEqual(target.hour, 8)
        XCTAssertEqual(target.minute, 17)
        XCTAssertEqual(target.second, 55)
        
        /*
        We only ensure nanoseconds are greater than zero
        because the nanoseond precision changes
        */
        XCTAssertGreaterThan(target.nanoSecond, 0)
    }
    
    func testToISODateWithTimeZoneSubtract() {
        let date = "2016-01-03T04:05:06.789-10:00".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2016)
        XCTAssertEqual(target.month, 1)
        XCTAssertEqual(target.day, 3)
        XCTAssertEqual(target.hour, 4)
        XCTAssertEqual(target.minute, 5)
        XCTAssertEqual(target.second, 6)
        
        /*
        We only ensure nanoseconds are greater than zero
        because the nanoseond precision changes
        */
        XCTAssertGreaterThan(target.nanoSecond, 0)
    }
}
