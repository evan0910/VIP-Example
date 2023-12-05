//
//  MoviesEndpoint.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation

enum MoviesSharedEndpoint {
    case topRated(parameters: [URLQueryItem])
    case nowPlaying(parameters: [URLQueryItem])
    case popular(parameters: [URLQueryItem])
    case upcoming(parameters: [URLQueryItem])
}

extension MoviesSharedEndpoint: IEndpoint {
    
    var URL: String {
        return BaseURL.api.rawValue
    }
    
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .popular:
            return "/3/movie/popular"
        case .upcoming:
            return "/3/movie/upcoming"
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
        case .nowPlaying(let parameters), .popular(let parameters), .topRated(let parameters), .upcoming(let parameters):
            return parameters
        }
    }
}
