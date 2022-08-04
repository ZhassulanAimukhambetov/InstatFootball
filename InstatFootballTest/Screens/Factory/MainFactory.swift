//
//  MainFactory.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

enum MainFactory {
    private static var client: NetworkService {
        Network()
    }
    
    private static var footbalService: FootballServiceProtocol {
        FootballService(client: client)
    }
    
    static func leaguesVC() -> UIViewController {
        let presenter = LeaguesPresenter(service: footbalService)
        let view = LeaguesViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    static func seasonsVC(for leagueId: String) -> UIViewController {
        let presenter = SeasonsPresenter(service: footbalService, leagueId: leagueId)
        let view = SeasonsViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
