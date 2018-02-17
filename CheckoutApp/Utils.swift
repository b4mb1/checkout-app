//
//  Utils.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

protocol UIIdentifiable {
    static var identifier: String { get }
    static var nib: UINib? { get }
}

extension UIIdentifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UICollectionViewCell: UIIdentifiable {
    
}

