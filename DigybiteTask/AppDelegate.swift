//
//  AppDelegate.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let homeVC = GameListViewController.instantiate(fromAppStoryboard: .main)
        let navController = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = navController
        return true
    }
}

