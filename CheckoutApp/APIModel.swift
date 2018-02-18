//
//  APIModel.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

struct ExchangeRates: Codable {
    let success: Bool
    let source: String
    let quotes: Quotes
    
    enum CodingKeys: String, CodingKey {
        case success
        case source
        case quotes
    }
}

//API has hardocded keys in JSON...

struct Quotes: Codable {
    let USDEUR: Double
    let USDGBP: Double
    let USDCAD: Double
    let USDPLN: Double
    let USDCHF: Double
    let USDINR: Double
    let USDBRL: Double
    let USDJPY: Double
    let USDARS: Double
}

struct APIError: Codable {
    let code: Int
    let info: String
}

enum AppError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

struct DataProvider {
    static let shared = DataProvider()
    
    private func buildURL() -> URL? {
        var components =  URLComponents(string: Constants.API.baseURL)
        
        let api = Constants.API.self
        let key = URLQueryItem(name: api.key, value: api.keyValue)
        let currencies = URLQueryItem(name: api.curr, value: api.currValue)
        let source = URLQueryItem(name: api.source, value: api.sourceValue)
        let format = URLQueryItem(name: api.format, value: api.formatValue)
        
        components?.queryItems = [key,currencies,source,format]
        return components?.url
    }
    
    func fetchRatesFor(_ currencies: [String], completionHandler: @escaping (ExchangeRates?, Error?) -> Void) {
        
        let reason = Constants.Errors.self
        guard let url = buildURL() else {
            let error = AppError.urlError(reason: reason.invalidURL)
            completionHandler(nil, error)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
        
            guard let responseData = data else {
                let error = AppError.objectSerialization(reason: reason.invalidData)
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let rates = try decoder.decode(ExchangeRates.self, from: responseData)
                completionHandler(rates, nil)
            } catch {
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

