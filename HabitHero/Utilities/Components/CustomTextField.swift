//
//  CustomTextField.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class CustomTextField: UIView {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.labelMedium
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitSecondaryBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let field = UITextField()
        field.font = Fonts.bodyMedium
        field.textColor = .habitTextPrimary
        field.tintColor = Colors.primary
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .habitTextSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitError
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [.foregroundColor: UIColor.habitTextTertiary]
            )
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
            iconImageView.isHidden = icon == nil
            updateIconConstraints()
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    var isSecureText: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureText
        }
    }
    
    var errorMessage: String? {
        didSet {
            errorLabel.text = errorMessage
            errorLabel.isHidden = errorMessage == nil
            updateBorderColor()
        }
    }
    
    // MARK: - Init
    init(title: String? = nil, placeholder: String? = nil, icon: UIImage? = nil) {
        super.init(frame: .zero)
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        addSubview(errorLabel)
        
        // Setup initial state
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        
        if let placeholder = placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.habitTextTertiary]
            )
        }
        
        if let icon = icon {
            iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        
        setupConstraints()
        setupTextFieldDelegation()
    }
    
    private func setupConstraints() {
        // Title Label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
        
        // Container View
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Icon ImageView
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        updateIconConstraints()
        
        // Error Label
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateIconConstraints() {
        textField.constraints.forEach { constraint in
            if constraint.firstAttribute == .leading {
                constraint.isActive = false
            }
        }
        
        if icon != nil {
            textField.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 12
            ).isActive = true
        } else {
            textField.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16
            ).isActive = true
        }
        
        textField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        textField.centerYAnchor.constraint(
            equalTo: containerView.centerYAnchor
        ).isActive = true
    }
    
    private func setupTextFieldDelegation() {
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Text Field Events
    @objc private func textFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.layer.borderColor = Colors.primary.cgColor
            self.containerView.layer.borderWidth = 2
        }
    }
    
    @objc private func textFieldDidEndEditing() {
        updateBorderColor()
    }
    
    private func updateBorderColor() {
        UIView.animate(withDuration: 0.2) {
            if self.errorMessage != nil {
                self.containerView.layer.borderColor = UIColor.habitError.cgColor
                self.containerView.layer.borderWidth = 2
            } else {
                self.containerView.layer.borderColor = UIColor.separator.cgColor
                self.containerView.layer.borderWidth = 1
            }
        }
    }
    
    // MARK: - Public Methods
    func validate(rules: [ValidationRule]) -> Bool {
        guard let text = text else {
            errorMessage = "This field is required"
            return false
        }
        
        for rule in rules {
            if !rule.validate(text) {
                errorMessage = rule.errorMessage
                shake()
                return false
            }
        }
        
        errorMessage = nil
        return true
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - Validation Rules
struct ValidationRule {
    let validate: (String) -> Bool
    let errorMessage: String
    
    static var notEmpty: ValidationRule {
        return ValidationRule(
            validate: { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            errorMessage: "This field cannot be empty"
        )
    }
    
    static var email: ValidationRule {
        return ValidationRule(
            validate: { text in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: text)
            },
            errorMessage: "Please enter a valid email address"
        )
    }
    
    static func minLength(_ length: Int) -> ValidationRule {
        return ValidationRule(
            validate: { $0.count >= length },
            errorMessage: "Must be at least \(length) characters"
        )
    }
    
    static func maxLength(_ length: Int) -> ValidationRule {
        return ValidationRule(
            validate: { $0.count <= length },
            errorMessage: "Must be at most \(length) characters"
        )
    }
}
