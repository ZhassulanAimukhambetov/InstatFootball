//
//  LeagueStandingPresenter.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol LeagueStandingPresenterProtocol {
    var view: LeagueStandingViewProtocol? { get set }
    var numberOfRows: Int { get }
    func viewLoaded()
    func model(for indexPath: IndexPath) -> LeagueStandingModel
}

final class LeagueStandingPresenter: LeagueStandingPresenterProtocol {
    private let service: FootballServiceProtocol
    private let leagueId: String
    private let season: String
    
    weak var view: LeagueStandingViewProtocol?
    
    private var standings: [Standing] = []
    
    var numberOfRows: Int {
        standings.count
    }
    
    init(service: FootballServiceProtocol, leagueId: String, season: String) {
        self.service = service
        self.leagueId = leagueId
        self.season = season
    }
    
    func viewLoaded() {
        view?.updateView(isLoading: true)
        service.fetchLeagueStanding(for: leagueId, season: season) { [weak self] result in
            self?.view?.updateView(isLoading: false)
            switch result {
            case .success(let response):
                self?.standings = response.data.standings
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> LeagueStandingModel {
        LeagueStandingModel(standing: standings[indexPath.row])
    }
}
