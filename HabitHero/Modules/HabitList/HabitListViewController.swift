//
//  HabitListViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit
import Combine

final class HabitListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HabitListViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: HabitListCoordinator?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        return table
    }()
    
    private lazy var progressRingView: ProgressRingView = {
        let view = ProgressRingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabitTapped)
        )
    }()
    
    // MARK: - Init
    init(viewModel: HabitListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchHabits()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "HabitHero"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(progressRingView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            progressRingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressRingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressRingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressRingView.heightAnchor.constraint(equalToConstant: 250),
            
            tableView.topAnchor.constraint(equalTo: progressRingView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateProgressRing()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateProgressRing() {
        let completed = viewModel.habits.filter { $0.isCompleted }.count
        let total = viewModel.habits.count
        progressRingView.updateProgress(
            completed: completed,
            total: total,
            streak: viewModel.currentStreak
        )
    }
    
    @objc private func addHabitTapped() {
        coordinator?.showAddHabit()
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HabitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HabitCell.identifier,
            for: indexPath
        ) as? HabitCell else {
            return UITableViewCell()
        }
        
        let habit = viewModel.habits[indexPath.row]
        cell.configure(with: habit)
        cell.onToggleCompletion = { [weak self] in
            self?.viewModel.toggleHabitCompletion(at: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HabitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let habit = viewModel.habits[indexPath.row]
        coordinator?.showHabitDetail(habit)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in
            self?.viewModel.deleteHabit(at: indexPath.row)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
