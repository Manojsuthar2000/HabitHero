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
    
    // MARK: - Navigation
    func didFinishAddingHabit() {
        navigationController.dismiss(animated: true) {
            self.delegate?.addHabitCoordinatorDidFinish(self)
        }
    }
    
    func didCancelAddingHabit() {
        navigationController.dismiss(animated: true) {
            self.delegate?.addHabitCoordinatorDidCancel(self)
        }
    }
}
