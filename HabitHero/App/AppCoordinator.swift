//
//  AppCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    // Child Coordinators
    private var habitListCoordinator: HabitListCoordinator?
    private var analyticsCoordinator: AnalyticsCoordinator?
    private var settingsCoordinator: SettingsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        setupTabBar()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setupTabBar() {
        // Configure TabBar appearance
        configureTabBarAppearance()
        
        // 1. Dashboard/Habits Tab
        let habitsNavController = UINavigationController()
        habitsNavController.tabBarItem = UITabBarItem(
            title: "Habits",
            image: UIImage(systemName: "checkmark.circle"),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")
        )
        habitListCoordinator = HabitListCoordinator(navigationController: habitsNavController)
        habitListCoordinator?.start()
        
        // 2. Analytics Tab
        let analyticsNavController = UINavigationController()
        analyticsNavController.tabBarItem = UITabBarItem(
            title: "Analytics",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        analyticsCoordinator = AnalyticsCoordinator(navigationController: analyticsNavController)
        analyticsCoordinator?.start()
        
        // 3. Settings Tab
        let settingsNavController = UINavigationController()
        settingsNavController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        settingsCoordinator = SettingsCoordinator(navigationController: settingsNavController)
        settingsCoordinator?.start()
        
        // Set ViewControllers
        tabBarController.viewControllers = [
            habitsNavController,
            analyticsNavController,
            settingsNavController
        ]
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // Selected item color
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.selected.iconColor = Colors.primary
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: Colors.primary]
        itemAppearance.normal.iconColor = .systemGray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
    }
}
