//
//  Store.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 20/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

protocol StoreSubscriber {
    func newState(_ state: State)
}

class Store {
    private var reducer: Reducer
    private(set) var state: State {
        didSet { propagate() }
    }
    
    var subscribers: [StoreSubscriber] = []
    
    static let shared = Store()
    
    private init() {
        self.reducer = Reducers.theReducer
        self.state = State.defaultState()
    }
    
    //MARK: Methods with internal access level
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
