//
//  SeasonModel.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

struct SeasonModel {
    let season: Season
    let leagueId: String
    
    var yearText: String {
        "\(season.year)"
    }
    
    var nameText: String {
        season.displayName
    }
    
    var dateText: String? {
        guard let start = format(date: season.startDate),
              let end = format(date: season.endDate) else {
            return nil
        }
        
        return "\(start) - \(end)"
    }
}

private extension SeasonModel {
    func format(date dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        dateFormatter.locale = Locale(identifier: "US")
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        dateFormatter.dateFormat = "d MMMM YYYY"
        
        return dateFormatter.string(from: date)
    }
}
