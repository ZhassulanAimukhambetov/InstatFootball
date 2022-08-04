//
//  LeaguesViewController.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    func updateView()
    func updateView(isLoading: Bool)
    func updateView(withError error: Error)
}

final class LeaguesViewController: UIViewController {
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
        tableView.register(LeagueCell.self)
        return tableView
    }()
    
    private let presenter: LeaguesPresenterProtocol
    
    init(presenter: LeaguesPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
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
        title = "Leagues"
    }
}

extension LeaguesViewController: LeaguesViewProtocol {
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
        showRepeatScreen { [weak self] in
            self?.presenter.viewLoaded()
        }
    }
}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeagueCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: presenter.model(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MainFactory.seasonsVC(for: presenter.model(for: indexPath))
        navigationController?.pushViewController(vc, animated: true)
    }
}
