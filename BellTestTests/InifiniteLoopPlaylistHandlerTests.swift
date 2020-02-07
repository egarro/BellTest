//
//  InifiniteLoopPlaylistHandlerTests.swift
//  BellTestTests
//
//  Created by Esteban on 2020-02-07.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import XCTest
@testable import BellTest

class InifiniteLoopPlaylistHandlerTests: XCTestCase {
    let videos = [Video(videoId: "Video 1", iconURL: "", author: "", description: "", duration: ""),
                  Video(videoId: "Video 2", iconURL: "", author: "", description: "", duration: ""),
                  Video(videoId: "Video 3", iconURL: "", author: "", description: "", duration: "")]
    let classToTest = InifiniteLoopPlaylistHandler()
    
    override func setUp() {
        classToTest.videos = videos
    }

    func test_current_video_returns_proper_index() {
        classToTest.setCurrentVideo(id: "Video 2")
        let currentVideo = classToTest.currentVideo
        
        XCTAssertTrue(currentVideo == 1, "Index of current video should be 1")
    }
    
    func test_getNext_function_works_properly() {
        classToTest.setCurrentVideo(id: "Video 2")
        var response = classToTest.getNext()
        XCTAssertEqual(response, "Video 3")
        
        response = classToTest.getNext()
        XCTAssertEqual(response, "Video 1", "Videos should loop infinitely, so go back to beginning after last video")
    }
    
    func test_getPrevious_function_works_properly() {
        classToTest.setCurrentVideo(id: "Video 2")
        var response = classToTest.getPrevious()
        XCTAssertEqual(response, "Video 1")
        
        response = classToTest.getPrevious()
        XCTAssertEqual(response, "Video 3", "Videos should loop infinitely, so go back to end after first video")
    }
}
