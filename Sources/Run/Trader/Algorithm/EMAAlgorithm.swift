//
//  EMAAlgorithm.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class EMAAlgorithm : CryptoAlg {
    var currentValue: NSDecimalNumber = 0.0
    func run(tradeHistory: [CurrencyData], periods : Int) -> NSDecimalNumber? {
        let limitToPeriodsEMA = tradeHistory.dropFirst(tradeHistory.count - periods)
        let limitToPeriodsSMA = tradeHistory.dropLast(periods).flatMap {$0}
        
        currentValue = SMAAlgorithm().run(tradeHistory: limitToPeriodsSMA, periods: periods)!
        for element in limitToPeriodsEMA {
            guard let price = element.close else {
                return nil
            }
            let _ = update(next: price, periods: (periods < tradeHistory.count ? periods : tradeHistory.count))
        }
        return currentValue
    }
    
    
    func update(next: NSDecimalNumber, periods : Int) -> NSDecimalNumber {
        let mult = NSDecimalNumber(value : 2).dividing(by:  NSDecimalNumber(value : periods + 1))
        let nextMinusEMA = (next.subtracting(currentValue))
        let prevMult = nextMinusEMA.multiplying(by: mult)
        let prevMultAdd = prevMult.adding(currentValue)
        currentValue = prevMultAdd
        return prevMultAdd
    }
    
}
