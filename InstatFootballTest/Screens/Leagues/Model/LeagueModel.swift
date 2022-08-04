//
//  LeagueModel.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

struct LeagueModel {
    let league: League
    
    var id: String {
        league.id
    }
    
    var nameText: String {
        league.name
    }
    
    var abbrText: String {
        league.abbr
    }
    
    var logoURL: String? {
        league.logos.light
    }
}
