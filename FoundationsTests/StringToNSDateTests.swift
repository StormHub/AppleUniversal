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
    
    func testToISODateEmptyString() {
        let date = "".toISODate()
        XCTAssertNil(date)
    }
    
    func testToISODateStandard() {
        let date = "2015-11-01T10:20:03Z".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2015)
        XCTAssertEqual(target.month,11)
        XCTAssertEqual(target.day,1)
        XCTAssertEqual(target.hour,10)
        XCTAssertEqual(target.minute, 20)
        XCTAssertEqual(target.second, 3)
        XCTAssertEqual(target.nanoSecond, 0)
    }
    
    func testToISODateLong() {
        let date = "2016-01-03T01:02:03.456Z".toISODate()
        XCTAssertNotNil(date)
        let target = date!
        
        XCTAssertEqual(target.year, 2016)
        XCTAssertEqual(target.month, 1)
        XCTAssertEqual(target.day, 3)
        XCTAssertEqual(target.hour, 1)
        XCTAssertEqual(target.minute, 2)
        XCTAssertEqual(target.second, 3)
        
        // TODO:Fix this
        //XCTAssertEqual(target.nanoSecond, 456)
    }
}
