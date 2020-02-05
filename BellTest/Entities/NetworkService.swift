//
//  NetworkService.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

typealias PlaylistsClosure = (Playlists)->Void
typealias PlaylistClosure  = (Playlist)->Void

protocol PlaylistsFetcher {
    func fetchPlaylists(completion: @escaping PlaylistsClosure)
}

protocol PlaylistFetcher {
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure)
}

protocol VideoSearcher {
    func searchVideo(queryString: String, pageString: String, completion: @escaping PlaylistClosure)
}

protocol AuthenticationReceiver {
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?)
}

@objc
class NetworkService: NSObject, PlaylistsFetcher, PlaylistFetcher, AuthenticationReceiver {
    private let service = GTLRYouTubeService()
    private var playlistsCB: PlaylistsClosure?
    private var playlistCB: PlaylistClosure?
    
// MARK: All Playlists:
    
    func fetchPlaylists(completion: @escaping PlaylistsClosure) {
        playlistsCB = completion
        let query = GTLRYouTubeQuery_PlaylistsList.query(withPart: "snippet,contentDetails")
        //query.additionalHTTPHeaders = ["If-None-Match":"\"Fznwjl6JEQdo1MGvHOGaz_YanRU/mGuSyL7krY5Gf6_NvB5J9Gg68EM\""]
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
        if let error = error {
           print("Error \(error.localizedDescription)")
           return
        }
        let lists = Playlists(response)
        playlistsCB?(lists)
        playlistsCB = nil
    }
    
// MARK: One Playlist details:
    
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
        if let error = error {
           print("Error \(error.localizedDescription)")
           return
        }
        let list = Playlist(response)
        playlistCB?(list)
        playlistCB = nil
    }
    
    public func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?) {
        service.authorizer = authorizer
    }
}

extension NetworkService: VideoSearcher {
    func searchVideo(queryString: String, pageString: String, completion: @escaping PlaylistClosure) {
           playlistCB = completion
           let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
           query.q = queryString
           query.pageToken = pageString
           query.maxResults = 50
           service.executeQuery(query,
                                delegate: self,
                                didFinish:#selector(displaySearchResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    @objc
    func displaySearchResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject response: GTLRYouTube_SearchListResponse,
                                       error: NSError?) {
        if let error = error {
           print("Search error \(error.localizedDescription)")
           return
        }
        
        print("Got results??")
        
        let list = Playlist(response)
        playlistCB?(list)
        playlistCB = nil
    }
}
