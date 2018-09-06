//
//  CurrencyData.swift
//  CryptoTrader
//
//  Created by Kent Guerriero on 1/6/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class CurrencyData {
    var date : Date?
    var open : NSDecimalNumber?
    var close : NSDecimalNumber?
    
    init(open : NSDecimalNumber?, close : NSDecimalNumber?, date : Date?){
        self.open = open
        self.close = close
        self.date = date
    }
}
