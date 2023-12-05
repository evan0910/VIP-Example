//
//  SearchEndpoint.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import Foundation

enum SearchEndpoint {
    case searchMovie(parameters: [URLQueryItem])
}

extension SearchEndpoint: IEndpoint {
    
    var URL: String {
        return BaseURL.api.rawValue
    }
    
    var path: String {
        switch self {
        case .searchMovie:
            return "/3/search/movie"
        }
    }

    var method: RequestMethod {
        return .get
    }

    var header: [String: String]? {
        guard let accessToken = Bundle.main.infoDictionary?["ACCESS_TOKEN"] as? String else {
            return [:]
        }
        return [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var body: [URLQueryItem]? {
        switch self {
        case .searchMovie(let parameters):
            return parameters
        }
    }
}
