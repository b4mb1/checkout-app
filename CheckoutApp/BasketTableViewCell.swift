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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
