//
//  String+Extension.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation
import UIKit

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    
    func getYear() -> String {
        let calendar = Calendar.current
        guard let date = self.toDate(withFormat: "yyyy-MM-dd") else { return "" }
        let components = calendar.dateComponents([.day,.month,.year], from: date)
        return String(components.year ?? 0)
    }
}
