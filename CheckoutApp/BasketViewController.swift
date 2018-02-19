//
//  BasketViewController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var currencyDropDown: DropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDropDown()
        configurePickerView()
        setupStore()
        
        DataProvider.shared.fetchRatesFor( , completionHandler: <#T##(ExchangeRates?, Error?) -> Void#>) {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        animateBasketButton(isAppearing: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBasketButton(isAppearing: false)
    }

    private func configurePickerView() {
        guard let pickerView = currencyDropDown.expandedView as? PickerView else {
            return
        }

        pickerView.items = ["CHF", "EUR", "FEF" ,"WEFWe", "WEF", "ERR"]
        pickerView.valueChanged = { [weak self] currency, row in
            self?.currencyDidChange(currency, row: row)
        }
    }
    
    private func configureDropDown() {
        currencyDropDown.delegate = self
    }
    
    private func setupStore(){
        let store = Store.shared
        store.subscribe(self)
    }
    
    private func currencyDidChange(_ currency: String, row: Int) {
        self.currencyDropDown.text = currency
        if let pickerView = currencyDropDown.expandedView as? PickerView {
            pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    /// Expands/collapse pickerView
    private func expand(textField: DropDownTextField?, expand: Bool = true) {
        if let element = textField {
            
            element.expand(expand)
            
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
            })
        }
    }
    
    private func animateBasketButton(isAppearing: Bool) {
        guard let navigationController = self.navigationController as? CustomNavigationController else{
            return
        }
        
        navigationController.animateBasketButton(isAppearing: isAppearing)
    }
}

extension BasketViewController: StoreSubscriber {
    func newState(_ state: State) {
        
    }
}

extension BasketViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let textField = textField as? DropDownTextField {
            self.expand(textField: textField, expand: !(textField.expanded))
            self.view.endEditing(true)
            return false
        }
        
        return true
    }
}

