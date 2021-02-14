//
//  AppDelegate.swift
//  OMDbApp
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupAppearance()
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        self.appCoordinator = AppCoordinator(navigationController: navigationController)
        self.appCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }

    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
    }
}

