//
//  HabitListCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class HabitListCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HabitListViewModel()
        let viewController = HabitListViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewController.title = "HabitHero"
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showAddHabit() {
        // TODO: Navigate to AddHabitViewController
        print("Navigate to Add Habit")
    }
    
    func showHabitDetail(_ habit: Habit) {
        // TODO: Navigate to Habit Detail
        print("Show habit: \(habit.title)")
    }
}
