//
//  AppCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var habitListCoordinator: HabitListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        habitListCoordinator = HabitListCoordinator(navigationController: navigationController)
        habitListCoordinator?.start()
    }
}
