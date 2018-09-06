//
//  EMACrossStrategy.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class EMACrossStrategy : Strategy {
    var mostRecentTradeHistory: [CurrencyData]?
    var currencyPair: CurrencyPair?
    
    var orders = [Order]()
    var orderSize = NSDecimalNumber(value: 1000)

    private let smallerEMAPeriod = 12
    private let largerEMAPeriod = 26
    
    private let smoothingSMAPeriod = 10
    private var smaData = [CurrencyData]()
    
    func run(mostRecentData: CurrencyData?) -> Order? {
        guard let tradeHistory = mostRecentTradeHistory, let mostRecentData = mostRecentData else {
            return nil
        }
        guard let smoothingSMA = calcSmoothingSMAPeriod(mostRecentData: mostRecentData) else {
            return nil
        }
        var tempTradeHistory = tradeHistory
        tempTradeHistory.append(smoothingSMA)
        
        if let (ema1Result, ema2Result) = calculateEMACross(tempTradeHistory: tempTradeHistory) {
            if let lastClose = mostRecentData.close , let currencyPair = currencyPair{
                return createOrder(ema1Result: ema1Result, ema2Result: ema2Result, lastClose: lastClose, currencyPair : currencyPair)
            } else {
                return nil
            }
        }
        return nil
    }
        
    
    private func calculateEMACross(tempTradeHistory : [CurrencyData]) -> (NSDecimalNumber, NSDecimalNumber)? {
        let firstEMAPeriod = smallerEMAPeriod
        let secondEMAPeriod = largerEMAPeriod
        
        let smaAlg = SMAAlgorithm()
        let ema1Alg = EMAAlgorithm()
        let ema2Alg = EMAAlgorithm()
        
        guard let smaResultFirst = smaAlg.run(tradeHistory: tempTradeHistory, periods : firstEMAPeriod), let smaResultSecond = smaAlg.run(tradeHistory: tempTradeHistory, periods : secondEMAPeriod) else {
            return nil
        }
        
        ema1Alg.currentValue = smaResultFirst
        ema2Alg.currentValue = smaResultSecond
        
        
        guard let ema1Result = ema1Alg.run(tradeHistory: tempTradeHistory, periods : firstEMAPeriod),  let ema2Result = ema2Alg.run(tradeHistory: tempTradeHistory, periods : secondEMAPeriod)  else {
            return nil
        }
        
        return (ema1Result, ema2Result)
    }
    
    private func calcSmoothingSMAPeriod(mostRecentData: CurrencyData) -> CurrencyData? {
        smaData.append(mostRecentData)
        if smaData.count < smoothingSMAPeriod {
            return nil
        }
        let smaAlg = SMAAlgorithm()
        let result = smaAlg.run(tradeHistory: smaData, periods: smoothingSMAPeriod)
        
        if smaData.count > smoothingSMAPeriod {
            smaData.removeFirst()
        }
        return CurrencyData(open: result, close: result, date: Date())
    }

    private func createOrder(ema1Result : NSDecimalNumber, ema2Result : NSDecimalNumber, lastClose : NSDecimalNumber, currencyPair : CurrencyPair) -> Order?{
        if ema1Result.compare(ema2Result) == ComparisonResult.orderedDescending && orders.last?.orderKind != OrderKind.Buy {
            let order = Order(orderKind: .Buy, orderPrice: lastClose, currencyPair: currencyPair, orderType: .Market, orderSize : orderSize)
            orders.append(order)
            return order
        } else if ema1Result.compare(ema2Result) == ComparisonResult.orderedAscending && orders.last?.orderKind != OrderKind.Sell {
            let order = Order(orderKind: .Sell, orderPrice: lastClose, currencyPair: currencyPair, orderType: .Market, orderSize : orderSize)
            orders.append(order)
            return order
        } else if ema1Result.compare(ema2Result) == ComparisonResult.orderedSame {
            return nil
        } else {
            return nil
        }
    }
}
