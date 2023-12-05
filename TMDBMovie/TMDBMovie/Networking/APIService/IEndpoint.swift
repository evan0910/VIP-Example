//
//  Endpoint.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 23/10/23.
//

import Foundation

protocol IEndpoint {
    var URL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [URLQueryItem]? { get }
}



