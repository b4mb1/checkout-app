//
//  Reducers.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 20/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

typealias Reducer = (_ state: State, _ action: Action) -> State

struct Reducers {
    static func basketWithItem(basket: [ShoppingItem], newItem: ShoppingItem, atIndex: Int) -> [ShoppingItem] {
        return basket.enumerated().map{ (offset: Int, item: ShoppingItem) -> ShoppingItem in
            if (offset == atIndex) {
                return newItem
            } else {
                return item
            }
        }
    }

    static func updateBasket(state: State, index: Int, qty: Int) -> State {
        let basketItem = state.basket[index]
        let flooredQty = max(0, basketItem.quantity + qty)
        let cappedQty = min(20, flooredQty)
        let newItem = ShoppingItem(product: basketItem.product,
                                   quantity: cappedQty)
        let newBasket = basketWithItem(basket: state.basket, newItem: newItem, atIndex: index)
        return State(basket: newBasket, fxRates: state.fxRates, currency: state.currency)
    }
    
    static func theReducer(state: State, action: Action) -> State  {
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
}



