//
//  AppDelegate.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let viewController = UIViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .systemBackground
        window.rootViewController = viewController
        viewController.view.backgroundColor = .blue
        self.window = window

        return true
    }
}

