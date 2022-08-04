//
//  FootballRouter.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

enum FootballRouter: NetworkRouter {
    case leagues
    case seasons(leagueId: String)
    case leagueStanding(leagueId: String, season: String)
    
    var baseUrl: String {
        "https://api-football-standings.azharimm.site"
    }
    
    var path: String {
        switch self {
        case .leagues:
            return "/leagues"
        case .seasons(let id):
            return "/leagues/\(id)/seasons"
        case .leagueStanding(let id, _):
            return "/leagues/\(id)/standings"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var parameters: Parameters {
        switch self {
        case .leagues, .seasons:
            return [:]
        case .leagueStanding(_, let season):
            return ["season": season, "sort": "asc"]
        }
    }
}
