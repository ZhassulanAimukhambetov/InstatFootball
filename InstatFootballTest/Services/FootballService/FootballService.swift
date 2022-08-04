//
//  FootballService.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol FootballServiceProtocol {
    func fetchLeagues(_ completion: @escaping (Result<LeaguesResponse, NetworkError>) -> Void)
    func fetchSeasons(for leagueId: String, _ completion: @escaping (Result<SeasonsResponse, NetworkError>) -> Void)
    func fetchLeagueStanding(for leagueId: String,
                             season: String,
                             _ completion: @escaping (Result<LeagueStandingResponse, NetworkError>) -> Void)
}

final class FootballService: FootballServiceProtocol {
    private let client: NetworkService
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func fetchLeagues(_ completion: @escaping (Result<LeaguesResponse, NetworkError>) -> Void) {
        client.execute(with: FootballRouter.leagues, completion: completion)
    }
    
    func fetchSeasons(for leagueId: String, _ completion: @escaping (Result<SeasonsResponse, NetworkError>) -> Void) {
        client.execute(with: FootballRouter.seasons(leagueId: leagueId), completion: completion)
    }
    
    func fetchLeagueStanding(for leagueId: String,
                             season: String,
                             _ completion: @escaping (Result<LeagueStandingResponse, NetworkError>) -> Void) {
        client.execute(with: FootballRouter.leagueStanding(leagueId: leagueId, season: season), completion: completion)
    }
}
