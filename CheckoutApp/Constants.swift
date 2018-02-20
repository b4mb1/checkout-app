//
//  Constants.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct API {
        static let baseURL = "http://apilayer.net/api/live"
        static let key = "access_key"
        static let keyValue = "772e8f137945688b635343c327107d9a"
        static let currencies  = "currencies"
        static let currenciesValue = "ARS,AUD,BRL,CAD,CHF,EUR,GBP,INR,JPY,PLN,USD"
        static let source = "source"
        static let sourceValue = "USD"
        static let format = "format"
        static let formatValue = "1"
    }
    
    struct Errors {
        static let invalidURL = "Provided URL is invalid"
        static let invalidData = "Could not deserialize the data"
        static let invalidJSON = "Could not parse the JSON"
        static let serverError = "Unknown server error"
    }
    
    struct ImageNames {
        static let basket = "basket"
        static let back = "back"
    }
    
    struct Storyboards {
        static let main = "Main"
    }
    
    static let animationDuration = 0.3
    static let borderThickness: CGFloat = 0.5
}
