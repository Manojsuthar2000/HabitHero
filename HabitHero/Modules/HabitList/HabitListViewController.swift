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
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Welcome Section
    private lazy var welcomeCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.primary.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var welcomeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        imageView.image = UIImage(systemName: "sparkles", withConfiguration: config)
        imageView.tintColor = Colors.primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Build Better Habits"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var welcomeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Track your daily habits, build streaks, and transform your life one day at a time."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // Progress Section
    private lazy var progressSectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today's Progress"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var progressRingView: ProgressRingView = {
        let view = ProgressRingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var streakInfoCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.accent.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var streakInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔥 Streak shows consecutive days you've completed all habits. Keep it going!"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // Habits Section
    private lazy var habitsSectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Habits"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var habitsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)
        table.isScrollEnabled = false // Disable table scroll since we're using scrollview
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        imageView.image = UIImage(systemName: "leaf.circle", withConfiguration: config)
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No habits yet!\nTap the + button to create your first habit."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
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
        setupNavigationBar()
        bindViewModel()
        viewModel.fetchHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHabits()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "HabitHero"
        view.backgroundColor = .systemBackground
        
        // Add scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add all sections to content view
        contentView.addSubview(welcomeCard)
        welcomeCard.addSubview(welcomeIcon)
        welcomeCard.addSubview(welcomeTitleLabel)
        welcomeCard.addSubview(welcomeSubtitleLabel)
        
        contentView.addSubview(progressSectionLabel)
        contentView.addSubview(progressRingView)
        contentView.addSubview(streakInfoCard)
        streakInfoCard.addSubview(streakInfoLabel)
        
        contentView.addSubview(habitsSectionLabel)
        contentView.addSubview(habitsCountLabel)
        contentView.addSubview(tableView)
        
        contentView.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Welcome Card
            welcomeCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            welcomeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            welcomeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            welcomeIcon.topAnchor.constraint(equalTo: welcomeCard.topAnchor, constant: 16),
            welcomeIcon.leadingAnchor.constraint(equalTo: welcomeCard.leadingAnchor, constant: 16),
            welcomeIcon.widthAnchor.constraint(equalToConstant: 40),
            welcomeIcon.heightAnchor.constraint(equalToConstant: 40),
            
            welcomeTitleLabel.topAnchor.constraint(equalTo: welcomeCard.topAnchor, constant: 16),
            welcomeTitleLabel.leadingAnchor.constraint(equalTo: welcomeIcon.trailingAnchor, constant: 12),
            welcomeTitleLabel.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -16),
            
            welcomeSubtitleLabel.topAnchor.constraint(equalTo: welcomeTitleLabel.bottomAnchor, constant: 4),
            welcomeSubtitleLabel.leadingAnchor.constraint(equalTo: welcomeIcon.trailingAnchor, constant: 12),
            welcomeSubtitleLabel.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -16),
            welcomeSubtitleLabel.bottomAnchor.constraint(equalTo: welcomeCard.bottomAnchor, constant: -16),
            
            // Progress Section
            progressSectionLabel.topAnchor.constraint(equalTo: welcomeCard.bottomAnchor, constant: 24),
            progressSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            progressSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            progressRingView.topAnchor.constraint(equalTo: progressSectionLabel.bottomAnchor, constant: 16),
            progressRingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            progressRingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            progressRingView.heightAnchor.constraint(equalToConstant: 200),
            
            // Streak Info Card
            streakInfoCard.topAnchor.constraint(equalTo: progressRingView.bottomAnchor, constant: 12),
            streakInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            streakInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            streakInfoLabel.topAnchor.constraint(equalTo: streakInfoCard.topAnchor, constant: 12),
            streakInfoLabel.leadingAnchor.constraint(equalTo: streakInfoCard.leadingAnchor, constant: 12),
            streakInfoLabel.trailingAnchor.constraint(equalTo: streakInfoCard.trailingAnchor, constant: -12),
            streakInfoLabel.bottomAnchor.constraint(equalTo: streakInfoCard.bottomAnchor, constant: -12),
            
            // Habits Section
            habitsSectionLabel.topAnchor.constraint(equalTo: streakInfoCard.bottomAnchor, constant: 24),
            habitsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            habitsCountLabel.centerYAnchor.constraint(equalTo: habitsSectionLabel.centerYAnchor),
            habitsCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: habitsSectionLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100), // Extra padding for tab bar
            
            // Empty State
            emptyStateView.topAnchor.constraint(equalTo: habitsSectionLabel.bottomAnchor, constant: 40),
            emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
        
        // Dynamic table view height
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 300)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabitTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addHabitTapped() {
        coordinator?.showAddHabit()
    }
    
    private func bindViewModel() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                self?.tableView.reloadData()
                self?.updateProgressRing()
                self?.updateTableViewHeight()
                self?.updateEmptyState()
                self?.updateHabitsCount()
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
    
    private func updateTableViewHeight() {
        // Calculate table view height based on content
        tableView.layoutIfNeeded()
        let height = max(tableView.contentSize.height, 100)
        tableViewHeightConstraint?.constant = height
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.habits.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func updateHabitsCount() {
        let count = viewModel.habits.count
        let completed = viewModel.habits.filter { $0.isCompleted }.count
        habitsCountLabel.text = "\(completed)/\(count) done"
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
