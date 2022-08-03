//
//  FootballService.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

protocol FootballService {
    func fetchLeagues(_ completion: @escaping (Result<LeaguesResponse, NetworkError>) -> Void)
}

struct FootballServiceImpl: FootballService {
    let client: NetworkService
    
    func fetchLeagues(_ completion: @escaping (Result<LeaguesResponse, NetworkError>) -> Void) {
        client.execute(with: FootballRouter.leagues, completion: completion)
    }
}
