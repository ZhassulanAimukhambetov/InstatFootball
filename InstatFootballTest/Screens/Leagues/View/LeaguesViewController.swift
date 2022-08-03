//
//  LeaguesViewController.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

protocol LeaguesView: AnyObject {
    func updateView()
    func updateView(isLoading: Bool)
    func updateView(withError error: Error)
}

final class LeaguesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.dataSource = self
        tableView.register(LeagueCell.self)
        tableView.delegate = self
        return tableView
    }()
    
    private let presenter: LeaguesPresenter
    
    init(presenter: LeaguesPresenter) {
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
    }
}

extension LeaguesViewController: LeaguesView {
    func updateView() {
        tableView.reloadData()
    }
    
    func updateView(isLoading: Bool) {
        print("Loading is - ", isLoading)
    }
    
    func updateView(withError error: Error) {
        print(error.localizedDescription)
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
}
