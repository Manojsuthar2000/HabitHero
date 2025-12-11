//
//  AIHabitSuggestionView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class AIHabitSuggestionView: UIView {
    
    // MARK: - Properties
    var onGetSuggestion: ((String) -> Void)?
    var onQuickSuggestionSelected: ((QuickSuggestion) -> Void)?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let sparkleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sparkles")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Habit Suggestions"
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tell us your goal and we'll suggest the perfect habit"
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextField: CustomTextField = {
        let field = CustomTextField(
            title: nil,
            placeholder: "e.g., I want to get healthier",
            icon: UIImage(systemName: "lightbulb.fill")
        )
        return field
    }()
    
    private let getSuggestionButton: CustomButton = {
        let button = CustomButton.primary(title: "Get AI Suggestion", size: .medium)
        button.setIcon(UIImage(systemName: "sparkles"), position: .left)
        return button
    }()
    
    private let suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodySmall
        label.textColor = .habitTextPrimary
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let quickSuggestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Quick Suggestions"
        label.font = Fonts.labelMedium
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quickSuggestionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var quickSuggestions: [QuickSuggestion] = []
    private var dividerTopToButtonConstraint: NSLayoutConstraint!
    private var dividerTopToSuggestionConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(containerView)
        
        // Header
        headerStackView.addArrangedSubview(sparkleImageView)
        headerStackView.addArrangedSubview(titleLabel)
        
        containerView.addSubview(headerStackView)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(inputTextField)
        containerView.addSubview(getSuggestionButton)
        containerView.addSubview(suggestionLabel)
        containerView.addSubview(dividerView)
        containerView.addSubview(quickSuggestionsLabel)
        containerView.addSubview(quickSuggestionsStackView)
        
        dividerTopToButtonConstraint = dividerView.topAnchor.constraint(equalTo: getSuggestionButton.bottomAnchor, constant: 20)
        dividerTopToSuggestionConstraint = dividerView.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor, constant: 20)
        
        dividerTopToButtonConstraint.isActive = true
        dividerTopToSuggestionConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            sparkleImageView.widthAnchor.constraint(equalToConstant: 24),
            sparkleImageView.heightAnchor.constraint(equalToConstant: 24),
            
            headerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            headerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            inputTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            getSuggestionButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 12),
            getSuggestionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            getSuggestionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            suggestionLabel.topAnchor.constraint(equalTo: getSuggestionButton.bottomAnchor, constant: 16),
            suggestionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            suggestionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            quickSuggestionsLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            quickSuggestionsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            quickSuggestionsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            quickSuggestionsStackView.topAnchor.constraint(equalTo: quickSuggestionsLabel.bottomAnchor, constant: 12),
            quickSuggestionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            quickSuggestionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            quickSuggestionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        getSuggestionButton.addTarget(self, action: #selector(getSuggestionTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func getSuggestionTapped() {
        guard let text = inputTextField.text, !text.trimmed.isEmpty else {
            inputTextField.errorMessage = "Please enter your goal"
            inputTextField.shake()
            return
        }
        
        inputTextField.resignFirstResponder()
        onGetSuggestion?(text)
    }
    
    // MARK: - Public Methods
    func showLoading() {
        getSuggestionButton.setLoading(true, title: "Thinking...")
    }
    
    func hideLoading() {
        getSuggestionButton.setLoading(false)
    }
    
    func showSuggestion(_ suggestion: String) {
        suggestionLabel.text = suggestion
        suggestionLabel.isHidden = false
        
        dividerTopToButtonConstraint.isActive = false
        dividerTopToSuggestionConstraint.isActive = true
        
        // Animate appearance
        suggestionLabel.alpha = 0
        suggestionLabel.fadeIn(duration: 0.3)
    }
    
    func setQuickSuggestions(_ suggestions: [QuickSuggestion]) {
        self.quickSuggestions = suggestions
        quickSuggestionsStackView.removeAllArrangedSubviews()
        
        // Show only first 3 suggestions
        Array(suggestions.prefix(3)).forEach { suggestion in
            let button = createQuickSuggestionButton(for: suggestion)
            quickSuggestionsStackView.addArrangedSubview(button)
        }
    }
    
    private func createQuickSuggestionButton(for suggestion: QuickSuggestion) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Appearance
        button.backgroundColor = .habitSecondaryBackground
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        // Create content stack
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.spacing = 12
        contentStack.alignment = .center
        contentStack.isUserInteractionEnabled = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: suggestion.icon)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = suggestion.category.color
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Text stack
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        
        let titleLabel = UILabel()
        titleLabel.text = suggestion.title
        titleLabel.font = Fonts.bodyMedium
        titleLabel.textColor = .habitTextPrimary
        
        let descLabel = UILabel()
        descLabel.text = suggestion.description
        descLabel.font = Fonts.caption1
        descLabel.textColor = .habitTextSecondary
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descLabel)
        
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(textStack)
        
        button.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -12)
        ])
        
        button.addTarget(self, action: #selector(quickSuggestionTapped(_:)), for: .touchUpInside)
        button.tag = quickSuggestions.firstIndex(where: { $0.title == suggestion.title }) ?? 0
        
        return button
    }
    
    @objc private func quickSuggestionTapped(_ sender: UIButton) {
        let suggestion = quickSuggestions[sender.tag]
        onQuickSuggestionSelected?(suggestion)
        
        // Animate button
        sender.bounce()
    }
}
