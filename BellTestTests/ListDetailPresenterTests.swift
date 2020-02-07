//
//  ListDetailPresenterTests.swift
//  BellTestTests
//
//  Created by Esteban on 2020-02-07.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import XCTest
@testable import BellTest

class ListDetailInteractorMock: ListDetailInteractorInput {
    var moveToListWasCalled = 0
    func moveListTo(videoID: String) {
        moveToListWasCalled += 1
    }
}

class ListDetailWireframeMock: ListDetailWireframeInterface {
    var dismissPlaylistWasCalled = 0
    var presentPlayerWasCalled = 0
    func dismissPlaylistDetailInterface() {
        dismissPlaylistWasCalled += 1
    }
    
    func presentPlayerInterface(for: String) {
        presentPlayerWasCalled += 1
    }
}

class ListDetailPresenterTests: XCTestCase {
    var classToTest: ListDetailEventHandler!
    let interactorMock = ListDetailInteractorMock()
    let wireframeMock = ListDetailWireframeMock()
    
    override func setUp() {
        classToTest = ListDetailPresenter(wireFrame: wireframeMock,
                                          interactor: interactorMock)
    }

    func test_after_tap_on_play_interactor_should_call_move_to_list_and_wireframe_should_call_present_player() {
        let moveToListCount = interactorMock.moveToListWasCalled
        let presentPlayerCount = wireframeMock.presentPlayerWasCalled
        
        classToTest.didTapOnPlay(for: "someID")
        
        let moveToListNewCount = interactorMock.moveToListWasCalled
        let presentPlayerNewCount = wireframeMock.presentPlayerWasCalled
        
        XCTAssertTrue(moveToListCount + 1 == moveToListNewCount, "When playing an item from playlist, interactor should be aware of the new playlist position")
        XCTAssertTrue(presentPlayerCount + 1 == presentPlayerNewCount, "When taping on playlist item, player should be presented too.")
    }
    
    func test_after_tap_on_back_interactor_should_dismiss_list_details_interface() {
        let dismissCount = wireframeMock.dismissPlaylistWasCalled
        classToTest.didTapOnBack()
        let dismissNewCount = wireframeMock.dismissPlaylistWasCalled
        
        XCTAssertTrue(dismissCount + 1 == dismissNewCount, "When taping on back, presenter should tell wireframe to dismiss the playlist")
    }
}

