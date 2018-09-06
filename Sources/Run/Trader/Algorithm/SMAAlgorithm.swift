//
//  SMAAlgorithm.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class SMAAlgorithm : CryptoAlg {
    var number = NSDecimalNumber.zero
    func run(tradeHistory : [CurrencyData], periods : Int) -> NSDecimalNumber? {
        if tradeHistory.count - periods < 0 {
            print("Not sufficient data")
            return nil
        }
        let limitToPeriods = tradeHistory.dropFirst(tradeHistory.count - periods)

        for element in limitToPeriods {
            
            guard let price = element.close else {
                continue
            }
            number = number.adding(price)
            
        }
        return number.dividing(by: NSDecimalNumber(value: (periods < tradeHistory.count ? periods : tradeHistory.count)))
    }
}
