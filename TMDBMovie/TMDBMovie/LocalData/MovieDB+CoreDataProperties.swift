//
//  MovieDB+CoreDataProperties.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 27/10/23.
//
//

import Foundation
import CoreData


extension MovieDB {

    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieDB> {
        return NSFetchRequest<MovieDB>(entityName: "MovieDB")
    }

    @NSManaged var id: Int32
    @NSManaged var title: String?
    @NSManaged var voteAverage: Double
    @NSManaged var popularity: Double
    @NSManaged var voteCount: Int32
    @NSManaged var releaseDate: Date?
    @NSManaged var posterPath: String?
    @NSManaged var overview: String?
    @NSManaged var genre: String
    @NSManaged var info: String
    
    static func < (lhs: MovieDB, rhs: MovieDB) -> Bool {
        return lhs.title?.lowercased() ?? "" < rhs.title?.lowercased() ?? ""
    }
}

extension MovieDB : Identifiable {

}
