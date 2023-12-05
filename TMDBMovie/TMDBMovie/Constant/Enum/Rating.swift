//
//  Rating.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 30/10/23.
//

import UIKit

enum Rating: String {
    case Good
    case Neutral
    case Bad
    case VeryBad = "Very Bad"
    
    init?(rating: Double) {
        if rating > 7.5 {
            self  = .Good
        } else if rating > 5.0 || rating == 0.0 {
            self = .Neutral
        } else if rating > 3.0 {
            self = .Bad
        } else { self = .VeryBad }
    }
    
    var color: UIColor {
        switch self {
        case .Good:
            return .systemGreen
        case .Neutral:
            return .lightGray
        case .Bad:
            return .orange
        case .VeryBad:
            return.red
        }
    }
    
}
