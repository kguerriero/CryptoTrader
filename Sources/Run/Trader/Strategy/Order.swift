//
//  Order.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/7/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class Order {
    var orderKind : OrderKind?
    var orderPrice : NSDecimalNumber?
    var currencyPair : CurrencyPair?
    var orderType : OrderType?
    var orderSize : NSDecimalNumber?
    
    init(orderKind : OrderKind, orderPrice : NSDecimalNumber, currencyPair : CurrencyPair, orderType : OrderType, orderSize : NSDecimalNumber) {
        self.orderType = orderType
        self.orderKind = orderKind
        self.orderPrice = orderPrice
        self.currencyPair = currencyPair
        self.orderSize = orderSize
    }
}

enum OrderKind : String {
    case Buy = "Buy"
    case Sell = "Sell"
}

enum OrderType : String {
    case Limit = "Limit"
    case Market = "Market"
    case Stop = "Stop"
}
