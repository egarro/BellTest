//
//  InifiniteLoopPlaylistHandler.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol PlaylistLoader {
    func loadPlaylist(playlist:Playlist)
    func setCurrentVideo(id: String)
}

class InifiniteLoopPlaylistHandler: PlaylistHandler, PlaylistLoader {
    var currentVideo = 0
    var totalVideos: Int {
        return videos.count
    }
    
    var videos: [Video] = []
    var converter = PlaylistConverter()
    
    func getPrevious() -> String {
        if currentVideo == 0 {
            currentVideo = totalVideos
        }
        currentVideo -= 1
        return videos[currentVideo].videoId
    }
    
    func getNext() -> String {
        if currentVideo == totalVideos - 1 {
            currentVideo = -1
        }
        currentVideo += 1
        return videos[currentVideo].videoId
    }
    
    func loadPlaylist(playlist:Playlist) {
        videos = converter.convert(playlist: playlist)
    }
    
    func setCurrentVideo(id: String) {
        guard let idx = videos.firstIndex(where: { $0.videoId == id }) else {
            currentVideo = 0
            return
        }
        currentVideo = idx
    }
}
