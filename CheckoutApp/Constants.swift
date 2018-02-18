//
//  Constants.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

struct Constants {
    
    struct API {
        static let baseURL = "http://apilayer.net/api/live"
        static let key = "access_key"
        static let keyValue = "772e8f137945688b635343c327107d9a"
        static let curr = "currencies"
        static let currValue = "EUR,GBP,CAD,PLN,CHF,AUD,JPY,BRL,INR,ARS"
        static let source = "source"
        static let sourceValue = "USD"
        static let format = "format"
        static let formatValue = "1"
    }
    
    struct Errors {
        static let invalidURL = "Provided URL is invalid"
        static let invalidData = "Could not deserialize the data"
    }
    
    struct ImageNames {
        static let basket = "basket"
        static let back = "back"
    }
    
    struct Storyboards {
        static let main = "Main"
    }
}