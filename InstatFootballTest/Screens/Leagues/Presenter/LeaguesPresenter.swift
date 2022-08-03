//
//  LeaguesPresenter.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol LeaguesPresenter {
    var numberOfRows: Int { get }
    func viewLoaded()
    func model(for indexPath: IndexPath) -> LeagueModel
}

final class LeaguesPresenterImpl: LeaguesPresenter {
    private let service: FootballService
    weak var view: LeaguesView?
    
    private var leagues: [League] = []
    
    var numberOfRows: Int {
        leagues.count
    }
    
    init(service: FootballService) {
        self.service = service
    }
    
    func viewLoaded() {
        view?.updateView(isLoading: true)
        service.fetchLeagues { [weak self] result in
            self?.view?.updateView(isLoading: false)
            switch result {
            case .success(let response):
                self?.leagues = response.data
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> LeagueModel {
        LeagueModel(league: leagues[indexPath.row])
    }
}
