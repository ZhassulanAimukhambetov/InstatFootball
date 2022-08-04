//
//  LeagueStandingViewController.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

protocol LeagueStandingViewProtocol: AnyObject {
    func updateView()
    func updateView(isLoading: Bool)
    func updateView(withError error: Error)
}

final class LeagueStandingViewController: UIViewController {
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        return loader
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(LeagueStandingCell.self)
        return tableView
    }()
    
    private let presenter: LeagueStandingPresenterProtocol
    
    init(presenter: LeagueStandingPresenterProtocol, title: String) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewLoaded()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(loader)
    }
}

extension LeagueStandingViewController: LeagueStandingViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func updateView(isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
            loader.isHidden = true
        }
    }
    
    func updateView(withError error: Error) {
        showRepeatScreen(withCancelButton: true) { [weak self] in
            self?.presenter.viewLoaded()
        }
    }
}


extension LeagueStandingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeagueStandingCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: presenter.model(for: indexPath))
        return cell
    }
}

