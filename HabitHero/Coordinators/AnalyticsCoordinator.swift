//
//  AnalyticsCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit

final class AnalyticsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = AnalyticsViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}
