//
//  Array+Extension.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation

extension Array {

    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}

extension Array where Element: Comparable {
    
    var indexOfMax: Index? {
        guard var maxValue = self.first else { return nil }
        var maxIndex = 0

        for (index, value) in self.enumerated() {
            if value > maxValue {
                maxValue = value
                maxIndex = index
            }
        }
        return maxIndex
    }

}
