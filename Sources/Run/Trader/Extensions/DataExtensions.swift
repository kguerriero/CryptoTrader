//
//  DataExtensions.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/8/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
