//
//  AppDelegate.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navVC = UINavigationController()
        
        let coordinator = AppCoordinator(navCon: navVC)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        
        self.window = window
        
        coordinator.start()
        return true
    }
}

