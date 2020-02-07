//
//  DateHelper.swift
//  BellTest
//
//  Created by Esteban on 2020-02-06.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol DateChecker {
    func dateString() -> String
}

protocol DownloadChecker {
    func shouldDownloadResource(lastStoredDate:String) -> Bool
}

typealias DateAndDownloadChecker = DateChecker & DownloadChecker

class DateHelper: DateAndDownloadChecker {
    let formatter = DateFormatter()
    let downloadIntervalSpam: TimeInterval
    
    init(downloadIntervalSpam: TimeInterval = 60, dateFormat: String) {
        self.downloadIntervalSpam = downloadIntervalSpam
        formatter.dateFormat = dateFormat
    }
    
    func dateString() -> String {
        return formatter.string(from: Date())
    }
    
    func shouldDownloadResource(lastStoredDate:String) -> Bool {
        let timeInterval = Date().timeIntervalSince(dateFrom(lastStoredDate))
        if timeInterval > downloadIntervalSpam {
            return true
        }
        return false
    }
    
    private func dateFrom(_ string: String) -> Date {
        return formatter.date(from: string) ?? Date()
    }
    
    static var defaultHelper: DateHelper {
        return DateHelper(downloadIntervalSpam: 60, dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    }
}
