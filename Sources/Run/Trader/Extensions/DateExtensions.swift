//
//  DateExtensions.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/8/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
