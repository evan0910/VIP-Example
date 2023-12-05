//
//  MovieListModel.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 25/10/23.
//

import Foundation

struct MovieListModel {

    struct Request {
        var page: Int
        var parameters: [URLQueryItem]? {
            return [URLQueryItem(name: "page", value: String(page))]
        }
    }
    
    struct SearchRequest {
        var query: String
        var parameters: [URLQueryItem]? {
            return [URLQueryItem(name: "query", value: query)]
        }
    }
    
    struct Response: Codable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [Movie]

        enum CodingKeys: String, CodingKey {
            case page
            case results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
    
    struct MoviesViewModel {
        let id: Int
        let movieTitle: String
        let rating: Rating
        let ratingValue: String
        let movieYear: String
        let movieCover: String
        var isWatched: Bool
    }
    
    struct Movie: Codable {        
        let adult: Bool?
        let genreIDS: [Int]?
        let id: Int?
        let originalLanguage: String?
        let originalTitle: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let releaseDate: String?
        let title: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case adult
            case overview
            case popularity
            case id
            case title
            case video
            case genreIDS = "genre_ids"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
}
