//
//  BasketTableViewCell.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 20/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var shoppingItem: (ShoppingItem, String)? {
        didSet {
            guard let product = shoppingItem?.0.product,
                let quantity = shoppingItem?.0.quantity,
                let currentPrice = shoppingItem?.1 else {
                    return
            }
            
            item?.text = product.name.capitalized + String(format: " x %d", quantity)
            price?.text = currentPrice
        }
    }
}
