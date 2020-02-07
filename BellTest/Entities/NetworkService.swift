//
//  NetworkService.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

typealias PlaylistsClosure = (Result<Playlists,NetworkError>)->Void
typealias PlaylistClosure  = (Result<Playlist,NetworkError>)->Void

protocol PlaylistsFetcher {
    func fetchPlaylists(etag: String?, completion: @escaping PlaylistsClosure)
}

protocol PlaylistFetcher {
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure)
}

protocol VideoSearcher {
    func searchVideo(etag: String?,
                     queryString: String,
                     pageString: String,
                     completion: @escaping PlaylistClosure)
}

protocol AuthenticationReceiver {
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?)
}


enum NetworkError: Error {
    case unchangedRecordUseCache
    case undecodableETag
    case unknown
}

@objc
class NetworkService: NSObject, AuthenticationReceiver {
    private let service = GTLRYouTubeService()
    private var playlistsCB: PlaylistsClosure?
    private var playlistCB: PlaylistClosure?
        
    public func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?) {
        service.authorizer = authorizer
    }
    
    private func convertToNetworkError(nsError:NSError?) -> NetworkError? {
        guard let error = nsError else { return nil }
        if error.description.contains("304") {
            return .unchangedRecordUseCache
        } else {
            print("Search error \(error.localizedDescription)")
            return .unknown
        }
    }
}

// MARK: One Playlist details:
extension NetworkService: PlaylistFetcher {
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure) {
           playlistCB = completion
           let query = GTLRYouTubeQuery_PlaylistItemsList.query(withPart: "snippet,contentDetails")
           query.playlistId = id
           query.maxResults = 50
           service.executeQuery(query,
                                delegate: self,
                                didFinish:#selector(displayPlaylistResultWithTicket(ticket:finishedWithObject:error:)))
        
    }
    
    @objc
    func displayPlaylistResultWithTicket(ticket: GTLRServiceTicket,
                                         finishedWithObject response: GTLRYouTube_PlaylistItemListResponse,
                                         error: NSError?) {
        if let error = convertToNetworkError(nsError: error) {
            playlistCB?(.failure(error))
            return
        }
        let list = Playlist(response)
        playlistCB?(.success(list))
        playlistCB = nil
    }
}

// MARK: All Playlists:
extension NetworkService: PlaylistsFetcher {
    func fetchPlaylists(etag: String? = nil, completion: @escaping PlaylistsClosure) {
        playlistsCB = completion
        let query = GTLRYouTubeQuery_PlaylistsList.query(withPart: "snippet,contentDetails")
        if let headerValue = etag {
            query.additionalHTTPHeaders = ["If-None-Match":headerValue]
        }
        query.mine = true
        query.maxResults = 50
        service.executeQuery(query,
                             delegate: self,
                             didFinish:#selector(displayPlaylistsResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    @objc
    func displayPlaylistsResultWithTicket(ticket: GTLRServiceTicket,
                                          finishedWithObject response: GTLRYouTube_PlaylistListResponse,
                                          error: NSError?) {
        if let error = convertToNetworkError(nsError: error) {
            playlistsCB?(.failure(error))
            return
        }
        let lists = Playlists(response)
        playlistsCB?(.success(lists))
        playlistsCB = nil
    }
}

// MARK: Video Search:
extension NetworkService: VideoSearcher {
    func searchVideo(etag: String? = nil,
                     queryString: String,
                     pageString: String,
                     completion: @escaping PlaylistClosure) {
           playlistCB = completion
           let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
           if let headerValue = etag {
                query.additionalHTTPHeaders = ["If-None-Match":headerValue]
           }
           query.q = queryString
           query.pageToken = pageString
           query.maxResults = 20
           service.executeQuery(query,
                                delegate: self,
                                didFinish:#selector(displaySearchResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    @objc
    func displaySearchResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject response: GTLRYouTube_SearchListResponse,
                                       error: NSError?) {
        if let error = convertToNetworkError(nsError: error) {
            playlistCB?(.failure(error))
            return
        }
        let list = Playlist(response)
        playlistCB?(.success(list))
        playlistCB = nil
    }
}
