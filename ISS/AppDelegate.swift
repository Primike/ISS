//
//  AppDelegate.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: ISSCoordinator?
    let navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Reachability.startMonitoring()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .systemBackground
        window.rootViewController = navigationController
        coordinator = ISSCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        self.window = window

        return true
    }
}
