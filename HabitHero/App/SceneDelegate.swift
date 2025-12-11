//
//  SceneDelegate.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        // Apply saved appearance mode
        window?.overrideUserInterfaceStyle = SettingsManager.shared.appearanceMode.userInterfaceStyle
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
    }
}
