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
    
    static func seasonsVC(for league: LeagueModel) -> UIViewController {
        let presenter = SeasonsPresenter(service: footbalService, leagueId: league.id)
        let view = SeasonsViewController(presenter: presenter, title: league.abbrText)
        presenter.view = view
        
        return view
    }
}
