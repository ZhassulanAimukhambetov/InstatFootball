//
//  LeagueResponse.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

struct LeaguesResponse: Decodable {
    let status: Bool
    let data: [League]
}

struct League: Decodable {
    let id: String
    let name: String
    let abbr: String
    let logos: Logos
    
    struct Logos: Decodable {
        let light: String
        let dark: String
    }
}
