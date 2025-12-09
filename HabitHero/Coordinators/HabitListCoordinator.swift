//
//  HabitListCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class HabitListCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private var addHabitCoordinator: AddHabitCoordinator?
    
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
        let coordinator = AddHabitCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        addHabitCoordinator = coordinator
        coordinator.start()
    }
    
    func showHabitDetail(_ habit: Habit) {
        // TODO: Navigate to Habit Detail
        print("Show habit: \(habit.title)")
    }
}

// MARK: - AddHabitCoordinatorDelegate
extension HabitListCoordinator: AddHabitCoordinatorDelegate {
    func addHabitCoordinatorDidFinish(_ coordinator: AddHabitCoordinator) {
        addHabitCoordinator = nil
        // Habit list will auto-refresh via NotificationCenter
    }
    
    func addHabitCoordinatorDidCancel(_ coordinator: AddHabitCoordinator) {
        addHabitCoordinator = nil
    }
}
