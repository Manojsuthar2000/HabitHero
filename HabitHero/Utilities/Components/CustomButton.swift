//
//  CustomButton.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class CustomButton: UIButton {
    
    // MARK: - Button Style
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case destructive
        case text
        case success
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return Colors.primary
            case .secondary:
                return Colors.secondary
            case .outline, .text:
                return .clear
            case .destructive:
                return .habitError
            case .success:
                return .habitSuccess
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .primary, .secondary, .destructive, .success:
                return .white
            case .outline:
                return Colors.primary
            case .text:
                return .habitTextPrimary
            }
        }
        
        var borderColor: UIColor? {
            switch self {
            case .outline:
                return Colors.primary
            default:
                return nil
            }
        }
    }
    
    // MARK: - Button Size
    enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }
        
        var font: UIFont {
            switch self {
            case .small: return Fonts.buttonSmall
            case .medium: return Fonts.buttonMedium
            case .large: return Fonts.buttonLarge
            }
        }
        
        var contentInsets: UIEdgeInsets {
            switch self {
            case .small: return UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            case .medium: return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            case .large: return UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
            }
        }
    }
    
    // MARK: - Properties
    private var buttonStyle: ButtonStyle
    private var buttonSize: ButtonSize
    private var isLoading = false
    private var activityIndicator: UIActivityIndicatorView?
    private var originalTitle: String?
    
    // MARK: - Init
    init(
        title: String,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium
    ) {
        self.buttonStyle = style
        self.buttonSize = size
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        self.buttonStyle = .primary
        self.buttonSize = .medium
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Appearance
        backgroundColor = buttonStyle.backgroundColor
        setTitleColor(buttonStyle.titleColor, for: .normal)
        titleLabel?.font = buttonSize.font
        
        // Border
        if let borderColor = buttonStyle.borderColor {
            layer.borderWidth = 2
            layer.borderColor = borderColor.cgColor
        }
        
        // Corner radius
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Content insets
        if #available(iOS 15.0, *) {
            configuration = nil
            contentEdgeInsets = buttonSize.contentInsets
        } else {
            contentEdgeInsets = buttonSize.contentInsets
        }
        
        // Height constraint
        heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true
        
        // Shadow (only for non-outline buttons)
        if buttonStyle != .outline && buttonStyle != .text {
            addShadow(opacity: 0.15, offset: CGSize(width: 0, height: 3), radius: 6)
        }
        
        // Tap animation
        addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
    
    // MARK: - Loading State
    func setLoading(_ loading: Bool, title: String? = nil) {
        isLoading = loading
        isEnabled = !loading
        
        if loading {
            originalTitle = titleLabel?.text
            setTitle(title ?? "", for: .normal)
            showActivityIndicator()
        } else {
            if let originalTitle = originalTitle {
                setTitle(originalTitle, for: .normal)
            }
            hideActivityIndicator()
        }
    }
    
    private func showActivityIndicator() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = buttonStyle.titleColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        indicator.startAnimating()
        activityIndicator = indicator
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    // MARK: - Style Updates
    func updateStyle(_ style: ButtonStyle) {
        buttonStyle = style
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        
        if let borderColor = style.borderColor {
            layer.borderWidth = 2
            layer.borderColor = borderColor.cgColor
        } else {
            layer.borderWidth = 0
        }
    }
    
    // MARK: - Icon Support
    func setIcon(_ image: UIImage?, position: IconPosition = .left) {
        guard let image = image else {
            setImage(nil, for: .normal)
            return
        }
        
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        setImage(tintedImage, for: .normal)
        tintColor = buttonStyle.titleColor
        
        switch position {
        case .left:
            semanticContentAttribute = .forceLeftToRight
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        case .right:
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        }
    }
    
    enum IconPosition {
        case left
        case right
    }
}

// MARK: - Convenience Initializers
extension CustomButton {
    
    /// Creates a primary button
    static func primary(title: String, size: ButtonSize = .medium) -> CustomButton {
        return CustomButton(title: title, style: .primary, size: size)
    }
    
    /// Creates a secondary button
    static func secondary(title: String, size: ButtonSize = .medium) -> CustomButton {
        return CustomButton(title: title, style: .secondary, size: size)
    }
    
    /// Creates an outline button
    static func outline(title: String, size: ButtonSize = .medium) -> CustomButton {
        return CustomButton(title: title, style: .outline, size: size)
    }
    
    /// Creates a destructive button
    static func destructive(title: String, size: ButtonSize = .medium) -> CustomButton {
        return CustomButton(title: title, style: .destructive, size: size)
    }
    
    /// Creates a text button
    static func text(title: String, size: ButtonSize = .medium) -> CustomButton {
        return CustomButton(title: title, style: .text, size: size)
    }
}
