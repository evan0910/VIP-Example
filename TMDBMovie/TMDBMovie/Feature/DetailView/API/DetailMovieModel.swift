//
//  DetailMovieModel.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation

struct DetailMovieModel {

    struct Request {
        var id: Int
    }
    
    struct Response: Codable {
        let adult: Bool?
        let backdropPath: String?
        let budget: Int?
        let genres: [Genres]?
        let id: Int?
        let imdbID: String?
        let originalTitle: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let productionCompanies: [ProductionCompanies]?
        let productionCountries: [ProductionCountries]?
        let releaseDate: String?
        let revenue: Int?
        let runtime: Int?
        let status: String?
        let tagline: String?
        let title: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Double?
        let languages: [SpokenLanguages]?

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case budget
            case genres
            case id
            case imdbID = "imdb_id"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case languages = "spoken_languages"
            case revenue,runtime,status,tagline,title,video
        }
    }
    
    struct DetailMovieViewModel {
        let id: Int
        let movieTitle: String
        let rating: Double
        let ratingValue: Double
        let movieYear: String
        let movieCover: String
        let backdropCover: String
        let isWatched: Bool
        let synopsis: String
        let genres: String
        let tagline: String
        let runtime: String
        let releaseDate: String
        let isAdult: Bool
        let popularity: Double
    }
    
    struct Genres: Codable {
        let id: Int?
        let name: String?
    }
    
    struct ProductionCompanies: Codable {
        let id: Int?
        let name: String?
        let originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case name,id
            case originCountry = "origin_country"
        }
    }
        
    struct ProductionCountries: Codable {
        let iso31661: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case iso31661 = "iso_3166_1"
        }
    }
        
    struct SpokenLanguages: Codable {
        let iso6391: String?
        let name: String?
        let englishName: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case iso6391 = "iso_639_1"
            case englishName = "english_name"
        }
    }
}
