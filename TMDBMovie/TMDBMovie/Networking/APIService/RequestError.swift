//
//  RequestError.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 23/10/23.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Wait a few moments and try your request again."
        }
    }
}
