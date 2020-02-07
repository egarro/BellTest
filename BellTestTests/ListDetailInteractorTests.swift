//
//  ListDetailInteractorTests.swift
//  BellTestTests
//
//  Created by Esteban on 2020-02-07.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import XCTest
@testable import BellTest

class PlaylistLoaderMock: PlaylistLoader {
    var loadPlaylistWasCalled = 0
    var setCurrentVideoWasCalled = 0
    func loadPlaylist(playlist: Playlist) {
        loadPlaylistWasCalled += 1
    }
    
    func setCurrentVideo(id: String) {
        setCurrentVideoWasCalled += 1
    }
}

class ListDetailInteractorTests: XCTestCase {
    var classToTest: ListDetailInteractorInput!
    let playloaderMock = PlaylistLoaderMock()
    
    override func setUp() {
        classToTest = ListDetailInteractor(playlistLoader: playloaderMock)
    }

    func test_move_list_to_calls_set_current_video_on_the_playlist_loader_once() {
        let currentCount = playloaderMock.setCurrentVideoWasCalled
        classToTest.moveListTo(videoID: "someID")
        let newCount = playloaderMock.setCurrentVideoWasCalled
        XCTAssertTrue(currentCount + 1 == newCount, "")
    }
}
