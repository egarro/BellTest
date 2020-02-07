//
//  DateHelper.swift
//  BellTest
//
//  Created by Esteban on 2020-02-06.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

class DateHelper {
    let formatter = DateFormatter()
    let downloadIntervalSpam: TimeInterval = 60
    
    init() {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
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
}
