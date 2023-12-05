//
//  Int+Extension.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 30/10/23.
//

import Foundation

extension Int {
    func calculateTime() -> String {
        let timeMeasure = Measurement(value: Double(self), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
            return String(format: "\(Int(hours.value))h \(Int(minutes))min")
        }
        return String(format: "\(timeMeasure.value)min")
    }
}
