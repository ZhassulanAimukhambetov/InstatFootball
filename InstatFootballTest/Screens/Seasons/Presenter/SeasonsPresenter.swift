//
//  SeasonsPresenter.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol SeasonsPresenterProtocol {
    var view: SeasonsViewProtocol? { get set }
    var numberOfRows: Int { get }
    func viewLoaded()
    func model(for indexPath: IndexPath) -> SeasonModel
}

final class SeasonsPresenter: SeasonsPresenterProtocol {
    private let service: FootballServiceProtocol
    private let leagueId: String
    weak var view: SeasonsViewProtocol?
    
    private var seasons: [Season] = []
    
    var numberOfRows: Int {
        seasons.count
    }
    
    init(service: FootballServiceProtocol, leagueId: String) {
        self.service = service
        self.leagueId = leagueId
    }
    
    func viewLoaded() {
        view?.updateView(isLoading: true)
        service.fetchSeasons(for: leagueId) { [weak self] result in
            self?.view?.updateView(isLoading: false)
            switch result {
            case .success(let response):
                self?.seasons = response.data.seasons
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> SeasonModel {
        SeasonModel(season: seasons[indexPath.row], leagueId: leagueId)
    }
}
