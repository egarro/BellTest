//
//  BusinessModels.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

struct Video {
    let videoId: String
    let iconURL: String
    let author: String
    let description: String
    let duration: String
}

struct User {
    let id: String
    let idToken: String
    let name: String
    let email: String
}

