//
//  BasketViewController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController, StoreSubscriber {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let navigationController = self.navigationController as? CustomNavigationController else{
           return
        }
       
        navigationController.hideBasketButton()
    }
    
    func newState(_ state: State) {
        
    }
}
