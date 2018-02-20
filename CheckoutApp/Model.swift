//
//  Model.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

typealias Reducer = (_ state: State, _ action: Action) -> State

// MARK: Redux model related protocols

protocol StoreSubscriber {
    func newState(_ state: State)
}


func basketWithItem(basket: [ShoppingItem], newItem: ShoppingItem, atIndex: Int) -> [ShoppingItem] {
    return basket.enumerated().map{ (offset: Int, item: ShoppingItem) -> ShoppingItem in
        if (offset == atIndex) {
            return newItem
        } else {
            return item
        }
    }
}

func updateBasket(state: State, index: Int, qty: Int) -> State {
    let basketItem = state.basket[index]
    let flooredQty = max(0, basketItem.quantity + qty)
    let cappedQty = min(20, flooredQty)
    let newItem = ShoppingItem(product: basketItem.product,
                               quantity: cappedQty)
    let newBasket = basketWithItem(basket: state.basket, newItem: newItem, atIndex: index)
    return State(basket: newBasket, fxRates: state.fxRates, currency: state.currency)
}


func theReducer(state: State, action: Action) -> State  {
    switch action {
    case .Increment(let index):
        return updateBasket(state: state, index: index, qty: 1)
    case .Decrement(let index):
        return updateBasket(state: state, index: index, qty: -1)
    case .UpdateRates(let newFxRates):
        return State(basket: state.basket, fxRates: newFxRates, currency: state.currency)
    case .SelectCurrency(let currency):
        return State(basket: state.basket, fxRates: state.fxRates, currency: currency)
        
    }
}

func defaultState() -> State {
    return State(basket: ProductLister.items, fxRates: ["USDUSD":1.0], currency: "USD")
}


class Store {
    private var reducer: Reducer
    private(set) var state: State {
        didSet { propagate() }
    }
    
    var subscribers: [StoreSubscriber] = []

    static let shared = Store()

    private init() {
        self.reducer = theReducer
        self.state = defaultState()
    }

    func dispatch(action: Action) {
        state = reducer(state, action)
    }
    
    func subscribe(_ newSubscriber: StoreSubscriber) {
        subscribers.append(newSubscriber)
    }
    
    func propagate() {
        DispatchQueue.main.async {
            self.subscribers.forEach { $0.newState(self.state) }
        }
    }
}

enum Action {
    case Increment(index: Int)
    case Decrement(index: Int)
    case UpdateRates(rates: [String:Double])
    case SelectCurrency(currency: String)
}

struct State {
    // inputs
    let basket: [ShoppingItem]
    
    let availableCurrencies: [String]
    let totalPrice: Double
    let totalPriceString: String
    let fxRates: [String: Double]
    
    let currency: String
    let fxRate: Double
    let priceBreakdown: [String: String]
    
    init(basket: [ShoppingItem], fxRates: [String:Double], currency: String) {
        self.basket = basket
        self.currency = currency
        self.fxRates = fxRates
        self.fxRate = fxRates["USD" + currency] ?? 1.0
        
        self.availableCurrencies = Array(fxRates.keys.map{String($0.dropFirst(3))}).sorted()

        self.totalPrice = State.calculateTotal(basket: self.basket, fxRate: self.fxRate)
        self.totalPriceString = State.formatPrice(price: self.totalPrice, currencyCode: self.currency)
        
        self.priceBreakdown = State.calculatePriceBreakdown(basket: self.basket, fxRate: self.fxRate, currencyCode: self.currency)
    }
    
    //  calculate total price for items in basket
    static func calculateTotal(basket: [ShoppingItem], fxRate: Double) -> Double {
        let usdTotal = basket.reduce(0, {(result:Double, shoppingItem:ShoppingItem) -> Double in
            result + Double(shoppingItem.quantity) * shoppingItem.product.price * fxRate
        })
        
        return usdTotal
    }
    
    static func calculatePriceBreakdown(basket: [ShoppingItem], fxRate: Double, currencyCode: String) -> [String: String] {
        let itemPriceTuples: [(String, String)] = basket.map{
            (
                $0.product.name,
                State.formatPrice(
                    price:$0.product.price * Double($0.quantity) * fxRate,
                    currencyCode: currencyCode
                )
            )
        }
        
        return Dictionary(uniqueKeysWithValues: itemPriceTuples)
    }
    

    // static func calculatePrices(basket: [ShoppingItem], fxRates: [String: Double]) -> [String: Double] {
    //     let usdTotal = calculateUSDTotal(basket: basket)
    //     return Dictionary(uniqueKeysWithValues: fxRates.map { ccy, rate in
    //         (String(ccy.dropFirst(3)), usdTotal * rate)
    //     })
    // }
    
    static func formatPrice(price: Double, currencyCode: String) -> String {
        let formatter = Formatter.currencyFormatter(code: currencyCode)
        return formatter.string(from: NSNumber(value: price))!
    }
}

enum Product {

    case peas
    case eggs
    case milk
    case beans

    var price : Double {
        switch  self {
        case .peas: return 0.95
        case .eggs: return 2.10
        case .milk: return 1.30
        case .beans: return 0.73
        }
    }
    
    var name: String {
        switch self {
        case .peas: return "peas"
        case .eggs: return "eggs"
        case .milk: return "milk"
        case .beans: return "beans"
        }
    }
    
    var per : String {
        switch  self {
        case .peas: return "per 100 g"
        case .eggs: return "per 20"
        case .milk: return "each"
        case .beans: return "per 100 g"
        }
    }
}

struct ShoppingItem {
    let product: Product
    let quantity: Int
    
    init(product: Product, quantity: Int = 0) {
        self.product = product
        self.quantity = quantity
    }
}

struct ProductLister {
    static let items: [ShoppingItem] = [ShoppingItem(product: .beans),
                                        ShoppingItem(product: .eggs),
                                        ShoppingItem(product: .milk),
                                        ShoppingItem(product: .peas)]
}
