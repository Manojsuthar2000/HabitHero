//
//  HabitDetailViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit
import Combine

final class HabitDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var habit: Habit
    private let habitRepository: HabitRepository
    private var cancellables = Set<AnyCancellable>()
    
    var onHabitUpdated: ((Habit) -> Void)?
    var onHabitDeleted: (() -> Void)?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Header Card
    private let headerCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryIconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let habitTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title2
        label.textColor = .habitTextPrimary
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodySmall
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stats Card
    private let statsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Details Card
    private let detailsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Notes Card
    private let notesCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodySmall
        label.textColor = .habitTextPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Action Buttons
    private let completeButton: CustomButton = {
        let button = CustomButton.primary(title: "Mark as Complete", size: .large)
        button.setIcon(UIImage(systemName: "checkmark.circle.fill"), position: .left)
        return button
    }()
    
    private let deleteButton: CustomButton = {
        let button = CustomButton.text(title: "Delete Habit", size: .medium)
        button.setTitleColor(.habitError, for: .normal)
        return button
    }()
    
    // MARK: - Init
    init(habit: Habit, habitRepository: HabitRepository = HabitRepository()) {
        self.habit = habit
        self.habitRepository = habitRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithHabit()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Habit Details"
        view.backgroundColor = .habitBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Header Card Setup
        headerCard.addSubview(categoryIconView)
        categoryIconView.addSubview(categoryIconImageView)
        headerCard.addSubview(habitTitleLabel)
        headerCard.addSubview(categoryLabel)
        
        // Stats Card Setup
        statsCard.addSubview(statsStackView)
        
        // Details Card Setup
        detailsCard.addSubview(detailsStackView)
        
        // Notes Card Setup
        notesCard.addSubview(notesLabel)
        
        // Add cards to content stack
        contentStackView.addArrangedSubview(headerCard)
        contentStackView.addArrangedSubview(statsCard)
        contentStackView.addArrangedSubview(detailsCard)
        contentStackView.addArrangedSubview(notesCard)
        contentStackView.addArrangedSubview(completeButton)
        contentStackView.addArrangedSubview(deleteButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            // Header Card
            categoryIconView.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 24),
            categoryIconView.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            categoryIconView.widthAnchor.constraint(equalToConstant: 60),
            categoryIconView.heightAnchor.constraint(equalToConstant: 60),
            
            categoryIconImageView.centerXAnchor.constraint(equalTo: categoryIconView.centerXAnchor),
            categoryIconImageView.centerYAnchor.constraint(equalTo: categoryIconView.centerYAnchor),
            categoryIconImageView.widthAnchor.constraint(equalToConstant: 28),
            categoryIconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            habitTitleLabel.topAnchor.constraint(equalTo: categoryIconView.bottomAnchor, constant: 16),
            habitTitleLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            habitTitleLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            
            categoryLabel.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            categoryLabel.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -24),
            
            // Stats Card
            statsStackView.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -20),
            
            // Details Card
            detailsStackView.topAnchor.constraint(equalTo: detailsCard.topAnchor, constant: 20),
            detailsStackView.leadingAnchor.constraint(equalTo: detailsCard.leadingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: detailsCard.trailingAnchor, constant: -20),
            detailsStackView.bottomAnchor.constraint(equalTo: detailsCard.bottomAnchor, constant: -20),
            
            // Notes Card
            notesLabel.topAnchor.constraint(equalTo: notesCard.topAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: notesCard.leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: notesCard.trailingAnchor, constant: -20),
            notesLabel.bottomAnchor.constraint(equalTo: notesCard.bottomAnchor, constant: -20),
        ])
        
        // Button actions
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func configureWithHabit() {
        // Header
        habitTitleLabel.text = habit.title
        categoryLabel.text = habit.category.rawValue
        categoryIconView.backgroundColor = habit.category.color
        categoryIconImageView.image = UIImage(systemName: habit.category.icon)
        
        // Stats
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        statsStackView.addArrangedSubview(createStatView(title: "Streak", value: "\(habit.streak)", icon: "flame.fill"))
        statsStackView.addArrangedSubview(createStatView(title: "Frequency", value: habit.frequency.rawValue, icon: "calendar"))
        statsStackView.addArrangedSubview(createStatView(title: "Status", value: habit.isCompleted ? "Done" : "Pending", icon: habit.isCompleted ? "checkmark.circle.fill" : "circle"))
        
        // Details
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        detailsStackView.addArrangedSubview(createDetailRow(title: "Created", value: habit.createdDate.formatted(date: .abbreviated, time: .omitted)))
        
        if let lastCompleted = habit.lastCompletedDate {
            detailsStackView.addArrangedSubview(createDetailRow(title: "Last Completed", value: lastCompleted.formatted(date: .abbreviated, time: .shortened)))
        }
        
        if let reminderTime = habit.reminderTime {
            detailsStackView.addArrangedSubview(createDetailRow(title: "Reminder", value: reminderTime.formatted(date: .omitted, time: .shortened)))
        }
        
        // Notes
        if let notes = habit.notes, !notes.isEmpty {
            notesCard.isHidden = false
            notesLabel.text = notes
        } else {
            notesCard.isHidden = true
        }
        
        // Update complete button state
        updateCompleteButtonState()
    }
    
    private func createStatView(title: String, value: String, icon: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = habit.category.color
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Fonts.title3
        valueLabel.textColor = .habitTextPrimary
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Fonts.caption1
        titleLabel.textColor = .habitTextSecondary
        titleLabel.textAlignment = .center
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(titleLabel)
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createDetailRow(title: String, value: String) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Fonts.bodySmall
        titleLabel.textColor = .habitTextSecondary
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Fonts.bodyMedium
        valueLabel.textColor = .habitTextPrimary
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        return stackView
    }
    
    private func updateCompleteButtonState() {
        if habit.isCompleted {
            completeButton.setTitle("Completed ✓", for: .normal)
            completeButton.backgroundColor = .habitSuccess
            completeButton.isEnabled = false
        } else {
            completeButton.setTitle("Mark as Complete", for: .normal)
            completeButton.backgroundColor = Colors.primary
            completeButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        Task {
            do {
                var updatedHabit = habit
                updatedHabit = Habit(
                    id: habit.id,
                    title: habit.title,
                    category: habit.category,
                    frequency: habit.frequency,
                    reminderTime: habit.reminderTime,
                    notes: habit.notes,
                    streak: habit.streak + 1,
                    lastCompletedDate: Date(),
                    createdDate: habit.createdDate,
                    isCompleted: true
                )
                
                try await habitRepository.updateHabit(updatedHabit)
                
                await MainActor.run {
                    self.habit = updatedHabit
                    self.configureWithHabit()
                    self.onHabitUpdated?(updatedHabit)
                    
                    // Show success feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            } catch {
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Delete Habit?",
            message: "Are you sure you want to delete \"\(habit.title)\"? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteHabit()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteHabit() {
        Task {
            do {
                try await habitRepository.deleteHabit(habit)
                
                await MainActor.run {
                    self.onHabitDeleted?()
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    showError(error)
                }
            }
        }
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
