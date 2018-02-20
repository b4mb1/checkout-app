//
//  Model.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

enum Action {
    case Increment(index: Int)
    case Decrement(index: Int)
    case UpdateRates(rates: [String:Double])
    case SelectCurrency(currency: String)
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
