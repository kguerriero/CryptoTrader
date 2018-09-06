//
//  Strategy.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/9/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

protocol Strategy {
    var mostRecentTradeHistory : [CurrencyData]? {get set}
    var currencyPair: CurrencyPair? {get set}
    
    func run(mostRecentData : CurrencyData?) -> Order?
    
}
