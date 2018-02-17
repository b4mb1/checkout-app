//
//  MainViewController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
   
    /**
     store = Store()
     viewController.dispatch = store.dispatch
     
     store.registerObserver(viewController.render)
     
    */
    
}

extension MainViewController: StoreSubscriber {
    func newState(_ state: State) {

    }
}

