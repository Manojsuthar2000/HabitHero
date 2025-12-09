//
//  AddHabitViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit
import Combine

final class AddHabitViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: AddHabitViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: AddHabitCoordinator?
    
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
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // AI Suggestion Section
    private let aiSuggestionView = AIHabitSuggestionView()
    
    // Form Fields
    private let nameTextField: CustomTextField = {
        let field = CustomTextField(
            title: "Habit Name",
            placeholder: "e.g., Morning Meditation",
            icon: UIImage(systemName: "pencil")
        )
        return field
    }()
    
    private let categoryPicker = CategoryPickerView()
    private let frequencyPicker = FrequencyPickerView()
    
    private let notesTextField: CustomTextField = {
        let field = CustomTextField(
            title: "Notes (Optional)",
            placeholder: "Add any details...",
            icon: UIImage(systemName: "text.alignleft")
        )
        return field
    }()
    
    private let reminderPicker = ReminderTimePickerView()
    
    // Bottom Buttons
    private let saveButton: CustomButton = {
        let button = CustomButton.primary(title: "Create Habit", size: .large)
        button.setIcon(UIImage(systemName: "plus.circle.fill"), position: .left)
        return button
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton.text(title: "Cancel", size: .medium)
        return button
    }()
    
    // MARK: - Init
    init(viewModel: AddHabitViewModel = AddHabitViewModel()) {
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
        setupActions()
        setupKeyboardHandling()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "New Habit"
        view.backgroundColor = .habitBackground
        
        // Navigation items
        navigationItem.largeTitleDisplayMode = .never
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        
        // Build content stack
        contentStackView.addArrangedSubview(aiSuggestionView)
        contentStackView.addArrangedSubview(createSectionSpacer())
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(categoryPicker)
        contentStackView.addArrangedSubview(frequencyPicker)
        contentStackView.addArrangedSubview(notesTextField)
        contentStackView.addArrangedSubview(reminderPicker)
        contentStackView.addArrangedSubview(createSectionSpacer())
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -12),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        // Set quick suggestions
        aiSuggestionView.setQuickSuggestions(viewModel.getQuickSuggestions())
    }
    
    private func createSectionSpacer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    // MARK: - Bindings
    private func bindViewModel() {
        // Name binding
        nameTextField.textField.addTarget(self, action: #selector(nameTextChanged), for: .editingChanged)
        
        // Notes binding
        notesTextField.textField.addTarget(self, action: #selector(notesTextChanged), for: .editingChanged)
        
        // Category binding
        categoryPicker.onCategorySelected = { [weak self] category in
            self?.viewModel.selectedCategory = category
        }
        
        // Frequency binding
        frequencyPicker.onFrequencySelected = { [weak self] frequency in
            self?.viewModel.selectedFrequency = frequency
        }
        
        // Reminder binding
        reminderPicker.onReminderToggled = { [weak self] enabled in
            self?.viewModel.isReminderEnabled = enabled
        }
        
        reminderPicker.onTimeChanged = { [weak self] time in
            self?.viewModel.reminderTime = time
        }
        
        // Loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.saveButton.setLoading(true, title: "Creating...")
                } else {
                    self?.saveButton.setLoading(false)
                }
            }
            .store(in: &cancellables)
        
        // Error handling
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
        
        // Name error
        viewModel.$nameError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.nameTextField.errorMessage = error
            }
            .store(in: &cancellables)
        
        // AI Suggestion
        viewModel.$isLoadingAISuggestion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.aiSuggestionView.showLoading()
                } else {
                    self?.aiSuggestionView.hideLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$aiSuggestion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestion in
                if let suggestion = suggestion {
                    self?.aiSuggestionView.showSuggestion(suggestion)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        aiSuggestionView.onGetSuggestion = { [weak self] goal in
            Task {
                await self?.viewModel.getAISuggestion(for: goal)
            }
        }
        
        aiSuggestionView.onQuickSuggestionSelected = { [weak self] suggestion in
            self?.viewModel.applyQuickSuggestion(suggestion)
            self?.updateUIFromViewModel()
        }
    }
    
    @objc private func nameTextChanged() {
        viewModel.habitName = nameTextField.text ?? ""
    }
    
    @objc private func notesTextChanged() {
        viewModel.notes = notesTextField.text ?? ""
    }
    
    @objc private func saveButtonTapped() {
        view.endEditing(true)
        
        Task {
            do {
                try await viewModel.saveHabit()
                await MainActor.run {
                    coordinator?.didFinishAddingHabit()
                }
            } catch {
                // Error handled by viewModel binding
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        let alert = UIAlertController(
            title: "Discard Habit?",
            message: "Are you sure you want to discard this habit?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.coordinator?.didCancelAddingHabit()
        })
        
        present(alert, animated: true)
    }
    
    private func updateUIFromViewModel() {
        nameTextField.text = viewModel.habitName
        notesTextField.text = viewModel.notes
        categoryPicker.setSelectedCategory(viewModel.selectedCategory)
        frequencyPicker.setSelectedFrequency(viewModel.selectedFrequency)
        
        UIView.animate(withDuration: 0.3) {
            self.nameTextField.pulse()
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
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Tap to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight - view.safeAreaInsets.bottom
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
