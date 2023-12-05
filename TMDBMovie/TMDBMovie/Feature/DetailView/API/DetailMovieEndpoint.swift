//
//  DetailMovieEndpoint.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation

enum DetailMovieEndpoint {
    case movieDetail(id: Int)
    case movieCast(id: Int)
}

extension DetailMovieEndpoint: IEndpoint {
    
    var URL: String {
        return BaseURL.api.rawValue
    }
    
    var path: String {
        switch self {
            case .movieDetail(let id):
                return "/3/movie/\(id)"
            case .movieCast(let id):
                return "/3/movie/\(id)/credits"
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
        return nil
    }
}
