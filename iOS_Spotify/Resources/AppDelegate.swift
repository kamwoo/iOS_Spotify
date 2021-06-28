//
//  AppDelegate.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 로그인 캐시되어있으면 홈화면으로
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSingedIn {
            AuthManager.shared.refreshForToken(completion: nil)
            window.rootViewController = TabBarViewController()
        }
        // 아니라면 로그인 화면으로
        else{
            let navVC = UINavigationController(rootViewController: WelcomeViewController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    // MARK: -UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

