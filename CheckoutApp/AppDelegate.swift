//
//  AppDelegate.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .black
        
        let store = Store.shared
        
        if let navigationController = window?.rootViewController as? CustomNavigationController,
            let viewController = navigationController.viewControllers[0] as? MainViewController {
            viewController.dispatch = store.dispatch
            store.subscribe(viewController)
            store.propagate()
        }

        return true
    }
}

