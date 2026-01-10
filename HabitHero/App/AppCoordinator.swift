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
    private var addHabitCoordinator: AddHabitCoordinator?
    private var analyticsCoordinator: AnalyticsCoordinator?
    private var settingsCoordinator: SettingsCoordinator?
    
    // Add Habit Navigation Controller (exposed for tab switching)
    private var addHabitNavController: UINavigationController?
    
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
        habitListCoordinator?.onAddHabitTapped = { [weak self] in
            self?.switchToAddTab()
        }
        habitListCoordinator?.start()
        
        // 2. Add Habit Tab
        let addNavController = UINavigationController()
        addNavController.tabBarItem = UITabBarItem(
            title: "Add",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        addHabitNavController = addNavController
        addHabitCoordinator = AddHabitCoordinator(navigationController: addNavController)
        addHabitCoordinator?.delegate = self
        addHabitCoordinator?.startAsTab()
        
        // 3. Analytics Tab
        let analyticsNavController = UINavigationController()
        analyticsNavController.tabBarItem = UITabBarItem(
            title: "Analytics",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        analyticsCoordinator = AnalyticsCoordinator(navigationController: analyticsNavController)
        analyticsCoordinator?.start()
        
        // 4. Settings Tab
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
            addNavController,
            analyticsNavController,
            settingsNavController
        ]
    }
    
    private func switchToAddTab() {
        tabBarController.selectedIndex = 1
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

// MARK: - AddHabitCoordinatorDelegate
extension AppCoordinator: AddHabitCoordinatorDelegate {
    func addHabitCoordinatorDidFinish(_ coordinator: AddHabitCoordinator) {
        // Switch back to Habits tab after saving
        tabBarController.selectedIndex = 0
        // Reset the Add Habit form for next use
        addHabitCoordinator?.resetForm()
    }
    
    func addHabitCoordinatorDidCancel(_ coordinator: AddHabitCoordinator) {
        // Switch back to Habits tab on cancel
        tabBarController.selectedIndex = 0
        // Reset the Add Habit form for next use
        addHabitCoordinator?.resetForm()
    }
}
