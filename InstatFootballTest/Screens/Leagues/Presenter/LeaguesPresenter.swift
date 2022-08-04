//
//  LeaguesPresenter.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol LeaguesPresenterProtocol {
    var view: LeaguesViewProtocol? { get set }
    var numberOfRows: Int { get }
    func viewLoaded()
    func model(for indexPath: IndexPath) -> LeagueModel
}

final class LeaguesPresenter: LeaguesPresenterProtocol {
    private let service: FootballServiceProtocol
    weak var view: LeaguesViewProtocol?
    
    private var leagues: [League] = []
    
    var numberOfRows: Int {
        leagues.count
    }
    
    init(service: FootballServiceProtocol) {
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
