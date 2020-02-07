//
//  NetworkCacheTests.swift
//  BellTestTests
//
//  Created by Esteban on 2020-02-07.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import XCTest
import CoreData
import GoogleAPIClientForREST
@testable import BellTest

class NetworkerMock: Networker {
    var authorizerSetterWasCalled = 0
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?) {
        authorizerSetterWasCalled += 1
    }
    //We test the successful result only for now
    func fetchPlaylists(etag: String?, completion: @escaping PlaylistsClosure) {
        completion(.success(Playlists()))
    }
    //We use the id parameter to simulate successful or failure responses
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure) {
        guard id != "" else {
            completion(.failure(NetworkError.unchangedRecordUseCache))
            return
        }
        completion(.success(Playlist()))
    }
    //We use the etag parameter to simulate successful or failure responses
    func searchVideo(etag: String?, queryString: String, pageString: String, completion: @escaping PlaylistClosure) {
        guard etag != nil else {
            completion(.failure(NetworkError.unchangedRecordUseCache))
            return
        }
        completion(.success(Playlist()))
    }
}

class DatabaseMock: DataBaseHandler {
    var createPlaylistsRecordWasCalled = 0
    var createPlaylistRecordWasCalled = 0
    var updatePlaylistRecordWasCalled = 0
    var findPlaylistsWasCalled = false
    var findPlaylistWasCalled = false
    
    func findPlaylists(with etag:String) -> Playlists? {
        findPlaylistsWasCalled = true
        return nil
    }
    
    func findPlaylist(with etag:String) -> Playlist? {
        findPlaylistWasCalled = true
        return nil
    }
    
    //Use this to simulate existance of an etag record.
    func getValue(for etag:String) -> String? {
        let desiredValue = etag.replacingOccurrences(of: playlistStorageKeyPrefix, with: "")
        if desiredValue == "" {
            return nil
        }
        return desiredValue
    }
    
    func createPlaylistsDBRecord(for record: Playlists, with tableId: String) {
        createPlaylistsRecordWasCalled += 1
    }
    
    func createPlaylistDBRecord(for record: Playlist, with tableId: String, withEtag: Bool) {
        createPlaylistRecordWasCalled += 1
    }
    
    func updatePlaylistDBRecord(with newPlaylist: Playlist, for tableId: String) {
        updatePlaylistRecordWasCalled += 1
    }
}


class NetworkCacheTests: XCTestCase {
    var classToTest: Networker!
    var basicNetworker = NetworkerMock()
    var databaseMock = DatabaseMock()
    
    let dateHelper = DateHelper(downloadIntervalSpam: 4,
                                dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    
    override func setUp() {
        classToTest = NetworkServiceWithCache(decorated: basicNetworker,
                                              databaseHandler: databaseMock,
                                              dateHelper: dateHelper)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_fetchPlaylists_upon_successful_response_new_record_should_be_created() {
        let createRecordCount = databaseMock.createPlaylistsRecordWasCalled
        
        classToTest.fetchPlaylists(etag: nil, completion: { _ in })

        let createRecordNewCount = databaseMock.createPlaylistsRecordWasCalled
        XCTAssertTrue(createRecordCount + 1 == createRecordNewCount, "When successful, internal database should add one playlists record")
    }
    
    func test_behaviour_when_young_enough_record_is_present() {
        let expectation1 = self.expectation(description: "Wait...")
        
        let createRecordCount = databaseMock.createPlaylistRecordWasCalled
        let updateRecordCount = databaseMock.updatePlaylistRecordWasCalled
        let simulatedValue = dateHelper.dateString()
        
        // Wait for the expectation to be fullfilled (never), so timeout and continue after 2 seconds.
        XCTWaiter().wait(for: [expectation1], timeout: 2)

        //Check DatabaseMock implementation: empty string will simulate not existance of record:
        classToTest.fetchPlaylist(id: simulatedValue, completion: { _ in })
        let createRecordNewCount = databaseMock.createPlaylistRecordWasCalled
        let updateRecordNewCount = databaseMock.updatePlaylistRecordWasCalled
        XCTAssertTrue(createRecordCount == createRecordNewCount, "If a young enough record is found, no new record should be created")
        XCTAssertTrue(updateRecordCount == updateRecordNewCount, "If a young enough record is found, no new record should be updated")
        XCTAssertTrue(databaseMock.findPlaylistWasCalled, "If a young enough record is found, attempt should be made to retrieve it")
    }
    
    func test_behaviour_when_old_record_is_present() {
        let expectation1 = self.expectation(description: "Wait...")
        
        let createRecordCount = databaseMock.createPlaylistRecordWasCalled
        let updateRecordCount = databaseMock.updatePlaylistRecordWasCalled
        let simulatedValue = dateHelper.dateString()
        
        // Wait for the expectation to be fullfilled (never), so timeout and continue after 2 seconds.
        XCTWaiter().wait(for: [expectation1], timeout: 5)

        //Check DatabaseMock implementation: empty string will simulate not existance of record:
        classToTest.fetchPlaylist(id: simulatedValue, completion: { _ in })
        let createRecordNewCount = databaseMock.createPlaylistRecordWasCalled
        let updateRecordNewCount = databaseMock.updatePlaylistRecordWasCalled
        XCTAssertTrue(createRecordCount == createRecordNewCount, "If an old record is found, no new record should be created but rather updated")
        XCTAssertTrue(updateRecordCount + 1 == updateRecordNewCount, "If an old record is found, that record should be updated!")
        XCTAssertFalse(databaseMock.findPlaylistWasCalled, "If a old record is found, no attempt should be made to retrieve it")
    }
}
