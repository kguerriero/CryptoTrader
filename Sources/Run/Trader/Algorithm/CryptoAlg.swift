//
//  CryptoAlgorithm.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Cocoa

protocol CryptoAlg {
    func run(tradeHistory : [CurrencyData], periods : Int) -> NSDecimalNumber?
    
}
