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

extension UIViewController: UIIdentifiable {
}

extension Collection {
    
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct Formatter {
    static func currencyFormatter(code: String = "USD") -> NumberFormatter {
        let formatter = NumberFormatter()
        let locale = localeForCurrencyCode(code: code)
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.currencySymbol = locale?.currencySymbol
        return formatter
    }
    
    static func localeForCurrencyCode(code: String) -> Locale? {
        guard let identifier = Locale.availableIdentifiers.first(where: { Locale(identifier: $0).currencyCode == code }) else { return nil}
        return Locale(identifier: identifier)
    }
}
