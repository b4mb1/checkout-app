//
//  BasketViewController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var currencyDropDown: DropDownTextField!
    
    private var basketItems: [(ShoppingItem, String)] = []
    
   //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDropDown()
        configurePickerView()
        Store.shared.subscribe(self)
        Store.shared.propagate()
        setupTableView()
        setupTitle()
        
        APIClient.shared.fetchRatesFor(Constants.API.currenciesValue) { rates, error in
           
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let rates = rates, let quotes = rates.quotes, !quotes.isEmpty  else {
                return
            }

            Store.shared.dispatch(action: Action.UpdateRates(rates: quotes))
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
    
    //MARK: Animations
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

//MARK: StoreSubscriber
extension BasketViewController: StoreSubscriber {
    func newState(_ state: State) {
        guard let pickerView = currencyDropDown.expandedView as? PickerView else {
            return
        }
        
        pickerView.items = Array(state.availableCurrencies)
        total.text = state.totalPriceString
        subtotal.text = state.totalPriceString
        basketItems = state.priceBreakdownStrings
        
        tableView.reloadData()
    }
}

//MARK: UITextFieldDelegate
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

//MARK: Helper
extension BasketViewController {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(BasketTableViewCell.nib, forCellReuseIdentifier: BasketTableViewCell.identifier)
    }

    private func setupTitle(){
        self.title = "YOUR CART"
    }
    
    private func configurePickerView() {
        guard let pickerView = currencyDropDown.expandedView as? PickerView else {
            return
        }
        
        pickerView.items = ["USD"]
        pickerView.valueChanged = { [weak self] currency, row in
            self?.currencyDidChange(currency, row: row)
        }
    }
    
    private func configureDropDown() {
        currencyDropDown.delegate = self
        currencyDropDown.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func currencyDidChange(_ currency: String, row: Int) {
        
        Store.shared.dispatch(action: Action.SelectCurrency(currency: currency))
        self.currencyDropDown.text = currency
        if let pickerView = currencyDropDown.expandedView as? PickerView {
            pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }
}

//MARK: UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item =  basketItems[safe:indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier,
                                                          for: indexPath) as? BasketTableViewCell else {
                                                            
                                                            return UITableViewCell()
        }
        
        cell.shoppingItem = item
        return cell
    }
}

