//
//  Exchange.swift
//  CryptoTrader
//
//  Created by Kent Guerriero on 1/6/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

protocol Exchange {
    var name : String {get set}
    var baseURL : URL {get set}
    var delegate : CryptoExchangeDelegate? {get set}
    
    func getTradeHistory(currencyPair : CurrencyPair, granularity : Int,  completion : @escaping (( [CurrencyData]?) -> ()))
    
    func configure(currencyPair : CurrencyPair)
    func useProductionAPI()
    
    
    func submit(order : Order, completion : @escaping ((Bool) -> ()))
    
}

protocol CryptoExchangeDelegate {
    func websocketDidReceiveCurrencyData(currencyData: CurrencyData)
}
