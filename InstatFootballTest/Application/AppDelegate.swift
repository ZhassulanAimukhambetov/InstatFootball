//
//  AppDelegate.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let presenter = LeaguesPresenterImpl(service: FootballServiceImpl(client: Network()))
        let vc = LeaguesViewController(presenter: presenter)
        presenter.view = vc
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }
}

