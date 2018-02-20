//
//  DropDownTextField.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 19/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class DropDownTextField: UITextField {
    
    /**
     IMPORTANT: make sure all constraints are configured to let @expandedView expand/collapse
     */
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandedView: UIView!
    
    var expanded = false
    
}
    
// MARK: Animations
extension DropDownTextField {
    
    fileprivate func turnArrow(up: Bool = true) {
        let transform = (up)
            ? CGAffineTransform(rotationAngle: CGFloat(Float.pi))
            : CGAffineTransform.identity
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.arrow?.transform = transform
        })
    }
}

// MARK: Expand
extension DropDownTextField {
    
    func expand(_ expand: Bool = true) {
        if (expand) {
            containerHeightConstraint?.constant = 170
        } else {
            containerHeightConstraint?.constant = 0
        }
        expanded = expand
        turnArrow(up: expand)
    }
}
