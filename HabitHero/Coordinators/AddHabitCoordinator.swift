//
//  AddHabitCoordinator.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

protocol AddHabitCoordinatorDelegate: AnyObject {
    func addHabitCoordinatorDidFinish(_ coordinator: AddHabitCoordinator)
    func addHabitCoordinatorDidCancel(_ coordinator: AddHabitCoordinator)
}

final class AddHabitCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AddHabitCoordinatorDelegate?
    
    private var addHabitViewController: AddHabitViewController?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    func start() {
        let viewModel = AddHabitViewModel()
        let viewController = AddHabitViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        let addHabitNav = UINavigationController(rootViewController: viewController)
        addHabitNav.modalPresentationStyle = .pageSheet
        
        // Configure sheet presentation
        if let sheet = addHabitNav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        navigationController.present(addHabitNav, animated: true)
    }
    
    /// Start as a tab (embedded in tab bar)
    func startAsTab() {
        let viewModel = AddHabitViewModel()
        let viewController = AddHabitViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewController.isTabMode = true
        viewController.title = "Add Habit"
        
        addHabitViewController = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    /// Reset the form for reuse
    func resetForm() {
        addHabitViewController?.resetForm()
    }
    
    // MARK: - Navigation
    func didFinishAddingHabit() {
        if addHabitViewController?.isTabMode == true {
            // In tab mode, notify delegate (which will switch tabs)
            delegate?.addHabitCoordinatorDidFinish(self)
        } else {
            // In modal mode, dismiss
            navigationController.dismiss(animated: true) {
                self.delegate?.addHabitCoordinatorDidFinish(self)
            }
        }
    }
    
    func didCancelAddingHabit() {
        if addHabitViewController?.isTabMode == true {
            // In tab mode, notify delegate (which will switch tabs)
            delegate?.addHabitCoordinatorDidCancel(self)
        } else {
            // In modal mode, dismiss
            navigationController.dismiss(animated: true) {
                self.delegate?.addHabitCoordinatorDidCancel(self)
            }
        }
    }
}
