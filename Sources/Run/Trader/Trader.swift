//
//  Trader.swift
//  CryptoTrader2
//
//  Created by Kent Guerriero on 1/8/18.
//  Copyright © 2018 Kent Guerriero. All rights reserved.
//

import Foundation

class Trader  {

    //Used for simulation purposes
    var balanceUSD : NSDecimalNumber = NSDecimalNumber(value : 1000)
    var balanceCrypto : NSDecimalNumber = NSDecimalNumber(value : 0)
    
    var currentStrategy : Strategy?
    var exchange : Exchange?
    var currencyPair : CurrencyPair?
    
    func processCommandlineArguments(){
        var useProduction = false
        for argument in CommandLine.arguments {
            
            switch argument.lowercased() {
            case "btc-xrb":
                currencyPair = CurrencyPair.BTCXRB
            case "btc-usd":
                currencyPair = CurrencyPair.BTCUSD
            case "eth-usd":
                currencyPair = CurrencyPair.ETHUSD
            case "emacross":
                currentStrategy = EMACrossStrategy()
            case "production":
                useProduction = true
                print("USING PRODUCTION API")
            default:
                print("an unknown argument \(argument)");
            }
        }
        
        verifyCommandlineArguments()
        exchange?.delegate = self
        if useProduction == true {
            exchange?.useProductionAPI()
        }
        
        currentStrategy?.currencyPair = currencyPair
    }
    
    private func verifyCommandlineArguments(){
        guard let exchange = exchange else {
            print("Please select an exchange")
            exit(-1)
        }
        
        guard let currencyPair = currencyPair else {
            print("Please select a currency pair")
            exit(-1)
        }
        exchange.configure(currencyPair: currencyPair)
    }
    

    func beginTrading(){
        guard let exchange = exchange, let currencyPair = currencyPair else {
            fatalError("Arguments not defined")
        }
        
        if #available(OSX 10.12, *) {
            let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (_) in
                exchange.getTradeHistory(currencyPair: currencyPair, granularity: 900) { (tradeHistory) in
                    guard let tradeHistory = tradeHistory else {
                        return
                    }
                    self.currentStrategy?.mostRecentTradeHistory = tradeHistory
                }
                
            }
            timer.fire()
        } else {
            // Fallback on earlier versions
        }
        
    }


}

extension Trader : CryptoExchangeDelegate {
    func websocketDidReceiveCurrencyData(currencyData : CurrencyData) {
       createOrderFrom(currencyData: currencyData)
    }
    
    fileprivate func createOrderFrom(currencyData : CurrencyData?){
        if let order = currentStrategy?.run(mostRecentData: currencyData) {
            self.executeOrder(order)
            self.writeOrderToFile(order: order)
            disableDelegateFor(seconds: 10)
        }
    }
    
    //Used so many buy/sell orders dont occur at same time
    fileprivate func disableDelegateFor(seconds : TimeInterval){
        self.exchange?.delegate = nil
        if #available(OSX 10.12, *) {
            Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { (_) in
                self.exchange?.delegate = self
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    fileprivate func executeOrder(_ order: Order) {
        if order.orderKind == OrderKind.Buy {
            if let price = order.orderPrice {
                self.balanceCrypto = self.balanceUSD.dividing(by: price)
                self.balanceUSD = NSDecimalNumber(value : 0)
            }
        }else if order.orderKind == OrderKind.Sell {
            if let price = order.orderPrice {
                if self.balanceCrypto.compare(NSDecimalNumber(value: 0)) != ComparisonResult.orderedSame {
                    self.balanceUSD = self.balanceCrypto.multiplying(by: price)
                    self.balanceCrypto = NSDecimalNumber(value : 0)
                }
            }
        }
    }
    
    fileprivate func writeOrderToFile(order : Order){
        var text = "BUY"
        if order.orderKind == OrderKind.Sell {
            text = "SELL"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let currentTime = formatter.string(from: Date())
        // text = text + currencyPair.rawValue
        text = text + " TIME:\(currentTime)"
        text = text + " PRICE:\(String(describing:  order.orderPrice!.description))"
        text = text + " CRYPTO: \(String(describing:  balanceCrypto.description))"
        text = text + " USD: \(String(describing:  balanceUSD.description)) \n"
        print(text)
        
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let url = dir.appendingPathComponent("orders.txt")
        try? text.appendToURL(fileURL: url)
    }

    
}
