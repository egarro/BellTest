//
//  SearchInteractor.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

class SearchInteractor: VideoSearcher {
    var networkService: VideoSearcher
    
    init(networkService: VideoSearcher) {
        self.networkService = networkService
    }
       
    func searchVideo(queryString: String, pageString: String, completion: @escaping PlaylistClosure) {
        networkService.searchVideo(queryString: queryString, pageString: pageString, completion: completion)
    }
}
