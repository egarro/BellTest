//
//  DateHelperTests.swift
//  BellTestTests
//
//  Created by Esteban on 2020-02-07.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import XCTest
@testable import BellTest

class DateHelperTests: XCTestCase {
    let classToTest = DateHelper(downloadIntervalSpam: 4,
                                 dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_if_shouldDownloadResource_return_false_before_downloadIntervalSpam_and_true_afterwards() {
        let expectation1 = self.expectation(description: "First wait...")
        let expectation2 = self.expectation(description: "Second wait...")
        let nowString = classToTest.dateString()
        
        // Wait for the expectation to be fullfilled (never), so timeout and continue after 2 seconds.
        XCTWaiter().wait(for: [expectation1], timeout: 2)
        var resp = classToTest.shouldDownloadResource(lastStoredDate: nowString)
        XCTAssertFalse(resp, "After only 2 seconds, we shouldn't download a new resource")
        
        // Wait again and timeout after 3 seconds.
        XCTWaiter().wait(for: [expectation2], timeout: 3)
        resp = classToTest.shouldDownloadResource(lastStoredDate: nowString)
        XCTAssertTrue(resp, "After 5 seconds, we should now download a new resource!")
    }
}
