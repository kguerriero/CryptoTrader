//
//  FormatterExtensions.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/8/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
