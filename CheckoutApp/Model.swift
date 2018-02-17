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

    func dispatch(action: Action) {
        
        // It doesnt have to be weakified,
        // store stays in the memory for whole app lifetime
        let reducer: Reducer = { _,_ in
            return self.state
        }
        
        state = reducer(self.state, action)
    }
    
    func addSubscriber(_ newSubscriber: StoreSubscriber) {
        subscribers.append(newSubscriber)
    }
}

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
    case peas(amount: Int)
    case eggs(amount: Int)
    case milk(amount: Int)
    case beans(amount: Int)
    
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
            return "Peas"
        case .eggs:
            return "Eggs"
        case .milk:
            return "Milk"
        case .beans:
            return "Beans"
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
    
    var imageName: String {
        switch  self {
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
}

struct Basket {
    let products: [Product]
}

struct ProductLister {
    static let products: [Product] = [.peas(amount: 1),
                               .milk(amount: 1),
                               .eggs(amount: 1),
                               .beans(amount: 1)]
}
