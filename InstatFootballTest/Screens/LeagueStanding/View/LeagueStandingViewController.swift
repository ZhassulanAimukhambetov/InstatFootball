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
    func updateModelView(with isHidden: Bool)
}

final class LeagueStandingViewController: UIViewController {
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        return loader
    }()
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(LeagueStandingCell.self)
        return tableView
    }()
    
    private lazy var modalView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let modalMenuViewController: ModalMenuViewController
    private var modalViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private let presenter: LeagueStandingPresenterProtocol
    
    init(presenter: LeagueStandingPresenterProtocol, title: String) {
        self.presenter = presenter
        self.modalMenuViewController = ModalMenuViewController(items: presenter.seasons)
        
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
        addRightButton()
        addModalView()
        presenter.viewLoaded()
    }
    
    private func setupView() {
        view.addSubview(mainTableView)
        view.addSubview(loader)
        view.addSubview(modalView)
        
        modalViewHeightConstraint = modalView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            modalViewHeightConstraint,
            modalView.widthAnchor.constraint(equalToConstant: 100),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            modalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func addModalView() {
        addChild(modalMenuViewController)
        guard let childView = modalMenuViewController.view else { return }
        childView.translatesAutoresizingMaskIntoConstraints = false
        modalView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            childView.topAnchor.constraint(equalTo: modalView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor)
        ])
        
        modalMenuViewController.didMove(toParent: self)
        modalMenuViewController.action = { [weak self] item in
            self?.presenter.updateSeason(with: item)
        }
    }
    
    private func addRightButton() {
        let barItem = UIBarButtonItem(title: "Seasons",
                                      style: .plain,
                                      target: self,
                                      action: #selector(tapSeasonsButton))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc private func tapSeasonsButton() {
        presenter.seasonsButtonTapped()
    }
}

extension LeagueStandingViewController: LeagueStandingViewProtocol {
    func updateView() {
        mainTableView.reloadData()
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
    
    func updateModelView(with isHidden: Bool) {
        modalViewHeightConstraint.constant = isHidden ? 0 : 300
        UIView.animate(withDuration: 0.3) {
            self.modalView.isHidden = isHidden
            self.view.layoutIfNeeded()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !modalView.isHidden {
            presenter.seasonsButtonTapped()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !modalView.isHidden {
            presenter.seasonsButtonTapped()
        }
    }
}
