//
//  State.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 20/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

struct State {
    let basket: [ShoppingItem]
    
    let availableCurrencies: [String]
    let totalPrice: Double
    let totalPriceString: String
    let fxRates: [String: Double]
    
    let currency: String
    let fxRate: Double
    let priceBreakdownStrings: [(ShoppingItem, String)]
    
    init(basket: [ShoppingItem], fxRates: [String:Double], currency: String) {
        self.basket = basket
        self.currency = currency
        self.fxRates = fxRates
        self.fxRate = fxRates["USD" + currency] ?? 1.0
        
        self.availableCurrencies = Array(fxRates.keys.map{String($0.dropFirst(3))}).sorted()
        
        self.totalPrice = State.calculateTotal(basket: self.basket, fxRate: self.fxRate)
        self.totalPriceString = State.formatPrice(price: self.totalPrice, currencyCode: self.currency)
        
        self.priceBreakdownStrings = State.calculatePriceBreakdown(basket: self.basket,
                                                                   fxRate: self.fxRate,
                                                                   currencyCode: self.currency)
    }
    
    static func defaultState() -> State {
        return State(basket: ProductLister.items, fxRates: ["USDUSD":1.0], currency: "USD")
    }

    
    static func calculateTotal(basket: [ShoppingItem], fxRate: Double) -> Double {
        let usdTotal = basket.reduce(0, {(result:Double, shoppingItem:ShoppingItem) -> Double in
            result + Double(shoppingItem.quantity) * shoppingItem.product.price * fxRate
        })
        
        return usdTotal
    }
    
    static func calculatePriceBreakdown(basket: [ShoppingItem], fxRate: Double,
                                        currencyCode: String) -> [(ShoppingItem, String)] {
        return basket.map{(
            $0,
            State.formatPrice(price:$0.product.price * Double($0.quantity) * fxRate, currencyCode: currencyCode)
        )}
    }
    
    static func formatPrice(price: Double, currencyCode: String) -> String {
        let formatter = Formatter.currencyFormatter(code: currencyCode)
        return formatter.string(from: NSNumber(value: price))!
    }
}
