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
    var seasons: [String] { get }
    
    func viewLoaded()
    func model(for indexPath: IndexPath) -> LeagueStandingModel
    func seasonsButtonTapped()
    func updateSeason(with season: String)
}

final class LeagueStandingPresenter: LeagueStandingPresenterProtocol {
    private let service: FootballServiceProtocol
    private let leagueId: String
    private let season: String
    let seasons: [String]
    
    weak var view: LeagueStandingViewProtocol?
    
    private var standings: [Standing] = []
    private var modalViewIsHidden: Bool = true
    
    var numberOfRows: Int {
        standings.count
    }
    
    init(service: FootballServiceProtocol,
         leagueId: String,
         season: String,
         seasons: [String]) {
        self.service = service
        self.leagueId = leagueId
        self.season = season
        self.seasons = seasons
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
    
    func seasonsButtonTapped() {
        modalViewIsHidden.toggle()
        view?.updateModelView(with: modalViewIsHidden)
    }
    
    func updateSeason(with season: String) {
        view?.updateModelView(with: true)
        standings = []
        view?.updateView()
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
        modalViewIsHidden = true
    }
}
