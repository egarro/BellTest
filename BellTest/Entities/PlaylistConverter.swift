//
//  PlaylistConverter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-05.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

class PlaylistConverter {
    public func convert(playlist: Playlist) -> [Video] {
        return playlist.items.map({ Video.init(videoId: $0.videoId,
                                               iconURL: $0.iconURL,
                                               author: $0.author,
                                               description: $0.title,
                                               duration: $0.duration) })
    }
}
