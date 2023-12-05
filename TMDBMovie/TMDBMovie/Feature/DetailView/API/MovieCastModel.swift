//
//  MovieCastModel.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 30/10/23.
//

import Foundation

struct MovieCastModel {

    struct Request {
        var id: Int
    }
    
    struct Response: Codable {
        let id: Int?
        let cast: [Cast]?
    }
    
    struct MovieCastViewModel {
        let name: String
        let photo: String
        let character: String
        let id: Int
    }
    
    struct Cast: Codable {
        let id: Int?
        let name: String?
        let profilePath: String?
        let character: String?
        
        enum CodingKeys: String, CodingKey {
            case id,name,character
            case profilePath = "profile_path"
        }
    }
}
