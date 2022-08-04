//
//  LeagueStandingResponse.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

struct LeagueStandingResponse: Decodable {
    let status: Bool
    let data: DataType
    
    struct DataType: Decodable {
        let name: String
        let abbreviation: String
        let seasonDisplay: String
        let season: Int
        let standings: [Standing]
    }
}

struct Standing: Decodable {
    let team: Team
    let note: Note?
    let stats: [Stat]
    
    struct Team: Decodable {
        let id: String
        let uid: String?
        let location: String?
        let name: String?
        let abbreviation: String?
        let displayName: String?
        let shortDisplayName: String?
        let isActive: Bool?
        let logos: [Logo]?
        
        struct Logo: Decodable {
            let href: String
            let width: Int?
            let height: Int?
            let lastUpdated: String?
        }
    }
    
    struct Note: Decodable {
        let color: String?
        let description: String?
        let rank: Int?
    }
    
    struct Stat: Decodable {
        let id: String?
        let name: String?
        let displayName: String?
        let shortDisplayName: String?
        let description: String?
        let abbreviation: String?
        let type: String?
        let value: Double?
        let summary: String?
        let displayValue: String?
    }
}
