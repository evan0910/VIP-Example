//
//  MoviesType.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 25/10/23.
//

import Foundation

enum MovieType: String {
    case nowPlaying = "Now Playing"
    case popular    = "Popular"
    case topRated   = "Top Rated"
    case upcoming   = "Upcoming"
    
    func getEndpoint(parameters: [URLQueryItem]) -> IEndpoint {
        switch self {
            case .popular:
                return MoviesSharedEndpoint.popular(parameters: parameters)
            case .nowPlaying:
                return MoviesSharedEndpoint.nowPlaying(parameters: parameters)
            case .topRated:
                return MoviesSharedEndpoint.topRated(parameters: parameters)
            case .upcoming:
                return MoviesSharedEndpoint.upcoming(parameters: parameters)
        }
    }
}
