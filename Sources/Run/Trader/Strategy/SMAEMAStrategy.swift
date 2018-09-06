//
//  SMAEMAStrategy.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class SMAEMAStrategy : Strategy {
    var mostRecentTradeHistory: [CurrencyData]?
    var currencyPair: CurrencyPair?
    
    var orders = [Order]()
    var orderSize = NSDecimalNumber(value: 1000)
    private var period = 20
    
    fileprivate func createOrder(_ emaResult: NSDecimalNumber, _ smaResult: NSDecimalNumber, _ lastClose : NSDecimalNumber, currencyPair : CurrencyPair) -> Order? {
        if emaResult.compare(smaResult) == ComparisonResult.orderedDescending {
            let order = Order(orderKind: .Buy, orderPrice: lastClose, currencyPair: currencyPair, orderType: .Market, orderSize : orderSize)
            orders.append(order)
            return order
        } else if emaResult.compare(smaResult) == ComparisonResult.orderedAscending {
            let order = Order(orderKind: .Sell, orderPrice: lastClose, currencyPair: currencyPair, orderType: .Market, orderSize : orderSize)
            orders.append(order)
            return order
        } else if emaResult.compare(smaResult) == ComparisonResult.orderedSame {
            return nil
        }
        return nil
    }
    
    func run(mostRecentData: CurrencyData?) -> Order? {
        guard let tradeHistory = mostRecentTradeHistory else {
            return nil
        }
        
        let smaAlg = SMAAlgorithm()
        let emaAlg = EMAAlgorithm()
        let periods = period
        guard let smaResult = smaAlg.run(tradeHistory: tradeHistory, periods : periods) else {
            return nil
        }
        emaAlg.currentValue = smaResult
        guard let emaResult = emaAlg.run(tradeHistory: tradeHistory, periods : periods) else {
            return nil
        }
        if let lastClose = tradeHistory.last?.close, let currencyPair = currencyPair {
            return createOrder(emaResult, smaResult, lastClose, currencyPair: currencyPair)
        } else {
            return nil
        }
    }
}
