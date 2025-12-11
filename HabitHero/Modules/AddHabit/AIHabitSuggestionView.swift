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
    var onAISuggestionSelected: ((AISuggestion) -> Void)?
    
    private var currentAISuggestion: AISuggestion?
    
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
    
    private let suggestionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitSecondaryBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = Colors.primary.cgColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let suggestionContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let suggestionIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let suggestionTextStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let suggestionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyMedium
        label.textColor = .habitTextPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private let suggestionDescLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.numberOfLines = 2
        return label
    }()
    
    private let suggestionBadge: UILabel = {
        let label = UILabel()
        label.text = "AI"
        label.font = Fonts.caption2
        label.textColor = .white
        label.backgroundColor = Colors.primary
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionChevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .habitTextTertiary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        
        // Setup suggestion card
        suggestionTextStack.addArrangedSubview(suggestionTitleLabel)
        suggestionTextStack.addArrangedSubview(suggestionDescLabel)
        
        suggestionContentStack.addArrangedSubview(suggestionIconView)
        suggestionContentStack.addArrangedSubview(suggestionTextStack)
        suggestionContentStack.addArrangedSubview(suggestionChevron)
        
        suggestionCardView.addSubview(suggestionContentStack)
        suggestionCardView.addSubview(suggestionBadge)
        containerView.addSubview(suggestionCardView)
        
        containerView.addSubview(dividerView)
        containerView.addSubview(quickSuggestionsLabel)
        containerView.addSubview(quickSuggestionsStackView)
        
        dividerTopToButtonConstraint = dividerView.topAnchor.constraint(equalTo: getSuggestionButton.bottomAnchor, constant: 20)
        dividerTopToSuggestionConstraint = dividerView.topAnchor.constraint(equalTo: suggestionCardView.bottomAnchor, constant: 20)
        
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
            
            // Suggestion Card
            suggestionCardView.topAnchor.constraint(equalTo: getSuggestionButton.bottomAnchor, constant: 16),
            suggestionCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            suggestionCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            suggestionCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            suggestionContentStack.topAnchor.constraint(equalTo: suggestionCardView.topAnchor, constant: 12),
            suggestionContentStack.leadingAnchor.constraint(equalTo: suggestionCardView.leadingAnchor, constant: 16),
            suggestionContentStack.trailingAnchor.constraint(equalTo: suggestionCardView.trailingAnchor, constant: -16),
            suggestionContentStack.bottomAnchor.constraint(equalTo: suggestionCardView.bottomAnchor, constant: -12),
            
            suggestionIconView.widthAnchor.constraint(equalToConstant: 32),
            suggestionIconView.heightAnchor.constraint(equalToConstant: 32),
            
            suggestionChevron.widthAnchor.constraint(equalToConstant: 16),
            suggestionChevron.heightAnchor.constraint(equalToConstant: 16),
            
            suggestionBadge.topAnchor.constraint(equalTo: suggestionCardView.topAnchor, constant: -6),
            suggestionBadge.trailingAnchor.constraint(equalTo: suggestionCardView.trailingAnchor, constant: -12),
            suggestionBadge.widthAnchor.constraint(equalToConstant: 24),
            suggestionBadge.heightAnchor.constraint(equalToConstant: 16),
            
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
        
        // Add tap gesture to suggestion card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(suggestionCardTapped))
        suggestionCardView.addGestureRecognizer(tapGesture)
        suggestionCardView.isUserInteractionEnabled = true
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
    
    func showSuggestion(_ suggestion: AISuggestion) {
        currentAISuggestion = suggestion
        
        // Configure the suggestion card
        suggestionTitleLabel.text = suggestion.habitName
        suggestionDescLabel.text = suggestion.benefits
        suggestionIconView.image = UIImage(systemName: suggestion.icon)
        suggestionIconView.tintColor = suggestion.category.color
        suggestionCardView.layer.borderColor = suggestion.category.color.cgColor
        suggestionBadge.backgroundColor = suggestion.category.color
        
        suggestionCardView.isHidden = false
        
        dividerTopToButtonConstraint.isActive = false
        dividerTopToSuggestionConstraint.isActive = true
        
        // Animate appearance
        suggestionCardView.alpha = 0
        suggestionCardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.suggestionCardView.alpha = 1
            self.suggestionCardView.transform = .identity
            self.layoutIfNeeded()
        }
    }
    
    func hideSuggestion() {
        currentAISuggestion = nil
        suggestionCardView.isHidden = true
        
        dividerTopToSuggestionConstraint.isActive = false
        dividerTopToButtonConstraint.isActive = true
    }
    
    @objc private func suggestionCardTapped() {
        guard let suggestion = currentAISuggestion else { return }
        
        // Animate tap
        UIView.animate(withDuration: 0.1, animations: {
            self.suggestionCardView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.suggestionCardView.transform = .identity
            }
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        onAISuggestionSelected?(suggestion)
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
