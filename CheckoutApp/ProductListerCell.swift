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
    
    var product: Product? {
        didSet {

            if let Product.beans(amount: Int) = product {
                image?.image = UIImage(named: product.imageName)
                price?.text = "\(product.price)"
                name?.text = product.name
                extra?.text = product.per
                quantity?.text = amount
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
