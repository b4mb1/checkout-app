//
//  ProductListerCell.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 17/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class ProductListerCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var extra: UILabel!
    @IBOutlet weak var addToBasket: UIButton!
    @IBOutlet weak var removeFromBasket: UIButton!
    @IBOutlet weak var quantity: UILabel!
    
    var item: ShoppingItem? {
        didSet {
            guard let product = item?.product,
            let quantity = item?.quantity else {
                return
            }
            
            image?.image = UIImage(named: product.name)
            price?.text = "\(product.price)"
            name?.text = product.name.uppercased()
            extra?.text = product.per
            self.quantity?.text = "\(quantity)"
        }
    }
}
