//
//  SettingsCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SettingsViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}
