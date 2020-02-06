//
//  NetworkModels.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

struct PlaylistInfo: Encodable, Decodable  {
    let identifier: String
    let title: String
    let numberOfItems: Int
    let iconURL: String
    
    init(_ pl:GTLRYouTube_Playlist) {
        numberOfItems = pl.contentDetails?.itemCount as? Int ?? -1
        title = pl.snippet?.title ?? "N/A"
        iconURL = pl.snippet?.thumbnails?.defaultProperty?.url ?? ""
        identifier = pl.identifier ?? ""
    }
}

struct Playlists: Encodable, Decodable {
    let etag: String
    let lists: [PlaylistInfo]
    
    init(_ pls: GTLRYouTube_PlaylistListResponse) {
        lists = pls.items?.map({ PlaylistInfo.init($0) }) ?? []
        etag = pls.eTag ?? ""
    }
}

struct Playlist: Encodable, Decodable{
    
    let etag: String
    let nextPage: String
    let items: [Item]
    
    init(_ pil:GTLRYouTube_PlaylistItemListResponse) {
        etag = pil.eTag ?? ""
        nextPage = pil.nextPageToken ?? ""
        if let x = pil.items {
            items = x.map({ Item.init($0) })
        } else {
            items = []
        }
    }
    
    init(_ pil:GTLRYouTube_SearchListResponse) {
        etag = pil.eTag ?? ""
        nextPage = pil.nextPageToken ?? ""
        if let x = pil.items {
            items = x.map({ Item.init($0) })
        } else {
            items = []
        }
    }
}

struct Item: Encodable, Decodable {
    let etag: String
    let id: String
    let title: String
    let playlistId: String
    let position: Int
    let iconURL: String
    let videoId: String
    let author: String
    let duration: String
    
    init(_ nItem:GTLRYouTube_PlaylistItem) {
        etag = nItem.eTag ?? ""
        id = nItem.identifier ?? ""
        title = nItem.snippet?.title ?? "N/A"
        playlistId = nItem.snippet?.playlistId ?? ""
        position = (nItem.snippet?.position as? Int) ?? -1
        iconURL = nItem.snippet?.thumbnails?.defaultProperty?.url ?? ""
        videoId = nItem.snippet?.resourceId?.videoId ?? ""
        author = nItem.snippet?.channelTitle ?? ""
        duration = nItem.contentDetails?.endAt ?? "N/A"
    }
    
    init(_ sr:GTLRYouTube_SearchResult) {
        etag = sr.eTag ?? ""
        id = sr.identifier?.videoId ?? ""
        title = sr.snippet?.title ?? "N/A"
        iconURL = sr.snippet?.thumbnails?.defaultProperty?.url ?? ""
        videoId = sr.identifier?.videoId ?? ""
        author = sr.snippet?.channelTitle ?? ""
        
        playlistId = ""
        position = -1
        duration = "N/A"
    }
}
