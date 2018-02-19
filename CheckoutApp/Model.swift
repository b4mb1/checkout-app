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

open class Store {
    static let shared = Store()
    private(set) var state = State() {
        didSet {

            //notify observers
            subscribers.forEach { $0.newState(state) }
        }
    }
    
    private var reducer: Reducer?
    private var isDispaching = false

    var subscribers: [StoreSubscriber] = []
    
    // let reducer: Reducer = { state, action in
    //     switch action {
    //     case Increment: reduceIncrement(state)
    //
    //     }
    //
    //     return self.state
    // }

    func dispatch(action: Action) {
        
        // It doesnt have to be weakified,
        // store stays in the memory for whole app lifetime

       // state = reducer(self.state, action)
    }
    
    func addSubscriber(_ newSubscriber: StoreSubscriber) {
        subscribers.append(newSubscriber)
    }
}

/*func reduceIncrement(state) = {
    new_state = state.copy()
    new_state.ModelState[index].qty += 1
}

*/
 
struct Action {
    struct Increment {
        let index: Int

    }
    
    struct Decrement {
        let index: Int
        
    }
    
    struct AddingToBasket {
        let index: Int
    }
    
    struct Checkout {
        
    }
    
    struct SelectingProduct {
        let index: Int
    
    }
}

struct State {

    struct ViewState {
        let selectedTab: Int
        
        struct ProductLister {
            let selectedView: Int
        }
        
        struct Checkout {
        }
    }
    
    struct  ModelState {
        let basket = Basket(products: [])
        let fxRates: [String: Double] = [:]
        let basketCount = 0
    }
}

enum Product {

    case peas
    case eggs
    case milk
    case beans

    var price : Double {
        switch  self {
        case .peas:
            return 0.95
        case .eggs:
            return 2.10
        case .milk:
            return 1.30
        case .beans:
            return 0.73
        }
    }
    
    var name: String {
        switch self {
        case .peas:
            return "peas"
        case .eggs:
            return "eggs"
        case .milk:
            return "milk"
        case .beans:
            return "beans"
        }
    }
    
    //TODO: Localization
    var per : String {
        switch  self {
        case .peas:
            return "per 100 g"
        case .eggs:
            return "per 10"
        case .milk:
            return "each"
        case .beans:
            return "per 100 g"
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

struct Basket {
    let products: [ShoppingItem]
}

struct ProductLister {
    static let items: [ShoppingItem] = [ShoppingItem(product: .beans),
                                           ShoppingItem(product: .eggs),
                                           ShoppingItem(product: .milk),
                                           ShoppingItem(product: .peas)]
}
