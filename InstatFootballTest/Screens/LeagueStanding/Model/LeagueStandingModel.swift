//
//  LeagueStandingModel.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

struct LeagueStandingModel {
    let standing: Standing
    
    var teamNameText: String? {
        standing.team.displayName
    }
    
    var logoURL: String? {
        standing.team.logos?.first?.href
    }
    
    var placeholderName: String {
        "team_placeholder"
    }
    
    var stats: [(key: String, value: String)] {
        standing.stats.compactMap { stat -> (String, String)? in
            guard let key = stat.displayName,
                  let value = stat.displayValue else {
                return nil
            }
            
            guard !key.isEmpty, !value.isEmpty else { return nil }
            
            return (key, value)
        }
    }
}
