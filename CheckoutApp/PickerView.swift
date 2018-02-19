//
//  PickerView.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 19/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    
    var valueChanged: ((_ value: String, _ row: Int) -> (Void))?
    
    var items: [String] = [] {
        didSet {
            reloadAllComponents()
        }
    }
    
    // MARK: Initializers
    required init(items: [String]) {
        super.init(frame:.zero)
        self.items = items
        delegate = self
        dataSource = self
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        setup()
    }
}

// MARK: Private UI
extension PickerView {
    
    fileprivate func setup() {
        
        tintColor = .black
        setValue(UIColor.lightGray, forKeyPath: "textColor")
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if items.count >= row {
            let item = items[row]
            valueChanged?(item, row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
}

