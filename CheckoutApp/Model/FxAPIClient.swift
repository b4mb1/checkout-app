//
//  APIModel.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 18/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let success: Bool
    let source: String?
    let quotes: [String:Double]?
    let error : APIError?
    
    enum CodingKeys: String, CodingKey {
        case success
        case source
        case quotes
        case error
    }
}

struct APIError: Codable {
    let code: Int
    let info: String
}

enum AppError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
    case JSONDecoding(reason: String)
    case apiError(reason: String)
}

struct APIClient {
    static let shared = APIClient()
    
    private func buildURLWith(_ currencies: String) -> URL? {
        var components =  URLComponents(string: Constants.API.baseURL)
        
        let api = Constants.API.self
        let key = URLQueryItem(name: api.key, value: api.keyValue)
        let currencies = URLQueryItem(name: api.currencies, value: currencies)
        let source = URLQueryItem(name: api.source, value: api.sourceValue)
        let format = URLQueryItem(name: api.format, value: api.formatValue)
        
        components?.queryItems = [key, currencies, source, format]
        return components?.url
    }
    
    func fetchRatesFor(_ currencies: String, completionHandler: @escaping (APIResponse?, Error?) -> Void) {
        
        let reason = Constants.Errors.self
        guard let url = buildURLWith(currencies) else {
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
                let response = try decoder.decode(APIResponse.self, from: responseData)
            
                if let apiError = response.error {
                    let error = AppError.apiError(reason: apiError.info)
                    completionHandler(nil, error)
                } else if !response.success {
                    let error = AppError.apiError(reason: reason.serverError)
                    completionHandler(nil, error)
                } else {
                    completionHandler(response, nil)
                }

            } catch {
                let error = AppError.JSONDecoding(reason: reason.invalidJSON)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

