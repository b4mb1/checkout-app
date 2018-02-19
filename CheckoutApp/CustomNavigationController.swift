//
//  CustomNavigationController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    private var basketButton: UIButton?
    private var basketBarButtonItem: UIBarButtonItem?

    private var backButton: UIButton?
    private var backBarButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasketButton()
        setupBackButton()
        self.delegate = self

    }

    private func setupBasketButton() {
        guard basketButton == nil else {
            return
        }
        
        let action = #selector(basketTapped)
        let name = Constants.ImageNames.basket
        basketButton = createCustomButton(withAction: action,
                                          andImageName: name)

        if let button = basketButton {
            basketBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    
    private func setupBackButton() {
        guard backButton == nil else {
            return
        }
        
        let action = #selector(backButtonTapped)
        let name = Constants.ImageNames.back
        backButton = createCustomButton(withAction: action,
                                        andImageName: name)

        if let button = backButton {
            backBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    private func createCustomButton(withAction action: Selector,
                                    andImageName name: String) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: .zero, size: CGSize(width: 25, height: 25))
        let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)

        return button
    }

    private func installBasketButtonOn(_ viewController: UIViewController){
        guard let basketItem = basketBarButtonItem else {
            return
        }
            viewController.navigationItem.rightBarButtonItem = basketItem
    }
    
    private func installBackButtonOn(_ viewController: UIViewController){
        guard let backItem = backBarButtonItem else {
            return
        }
        
        viewController.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func basketTapped() {
        basketButton?.isHidden = true
        let basketViewController = UIStoryboard(name: Constants.Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: BasketViewController.identifier)
        self.pushViewController(basketViewController, animated: true)
    }
    
    @objc func backButtonTapped() {
       self.popViewController(animated: true)
    }
    
    // MARK: methods with internal access level
    
    internal func animateBasketButton(isAppearing: Bool) {
        guard let button = basketButton else {
            return
        }
        
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
            button.isHidden = !isAppearing
        })
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
       
        backButton?.isHidden = false
        installBasketButtonOn(viewController)
        
        guard navigationController.viewControllers.count > 1 else {
            backButton?.isHidden = true
            return
        }
        
        installBackButtonOn(viewController)
    }
}
