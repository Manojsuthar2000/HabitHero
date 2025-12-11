//
//  AppearanceViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit

final class AppearanceViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedMode: AppearanceMode
    
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
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Preview Card
    private let previewCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.font = Fonts.labelMedium
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Mode Selection Card
    private let modeCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let modeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Appearance"
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let modeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var modeButtons: [AppearanceModeButton] = []
    
    // MARK: - Init
    init() {
        self.selectedMode = SettingsManager.shared.appearanceMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateSelection()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Appearance"
        view.backgroundColor = .habitBackground
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Setup preview
        setupPreviewCard()
        
        // Setup mode selection
        setupModeCard()
        
        // Add cards to stack
        contentStackView.addArrangedSubview(previewCard)
        contentStackView.addArrangedSubview(modeCard)
        
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
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func setupPreviewCard() {
        previewCard.addSubview(previewLabel)
        previewCard.addSubview(previewStackView)
        
        // Light preview
        let lightPreview = createPreviewView(isDark: false)
        
        // Dark preview
        let darkPreview = createPreviewView(isDark: true)
        
        previewStackView.addArrangedSubview(lightPreview)
        previewStackView.addArrangedSubview(darkPreview)
        
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: previewCard.topAnchor, constant: 16),
            previewLabel.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            
            previewStackView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 16),
            previewStackView.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            previewStackView.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -16),
            previewStackView.bottomAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: -16),
            previewStackView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func createPreviewView(isDark: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = isDark ? UIColor(white: 0.1, alpha: 1.0) : .white
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Mini header
        let headerView = UIView()
        headerView.backgroundColor = isDark ? UIColor(white: 0.15, alpha: 1.0) : UIColor.systemGray6
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleBar = UIView()
        titleBar.backgroundColor = isDark ? UIColor(white: 0.3, alpha: 1.0) : UIColor.systemGray4
        titleBar.layer.cornerRadius = 3
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Mini cards
        let card1 = createMiniCard(isDark: isDark, color: Colors.primary)
        let card2 = createMiniCard(isDark: isDark, color: .systemOrange)
        let card3 = createMiniCard(isDark: isDark, color: .systemGreen)
        
        // Label
        let label = UILabel()
        label.text = isDark ? "Dark" : "Light"
        label.font = Fonts.caption1
        label.textColor = isDark ? .white : .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(headerView)
        headerView.addSubview(titleBar)
        container.addSubview(card1)
        container.addSubview(card2)
        container.addSubview(card3)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 30),
            
            titleBar.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleBar.widthAnchor.constraint(equalToConstant: 50),
            titleBar.heightAnchor.constraint(equalToConstant: 6),
            
            card1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            card1.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            card1.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            card1.heightAnchor.constraint(equalToConstant: 30),
            
            card2.topAnchor.constraint(equalTo: card1.bottomAnchor, constant: 6),
            card2.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            card2.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            card2.heightAnchor.constraint(equalToConstant: 30),
            
            card3.topAnchor.constraint(equalTo: card2.bottomAnchor, constant: 6),
            card3.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            card3.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            card3.heightAnchor.constraint(equalToConstant: 30),
            
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        return container
    }
    
    private func createMiniCard(isDark: Bool, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = isDark ? UIColor(white: 0.2, alpha: 1.0) : UIColor.systemGray6
        card.layer.cornerRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let indicator = UIView()
        indicator.backgroundColor = color
        indicator.layer.cornerRadius = 4
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        let line1 = UIView()
        line1.backgroundColor = isDark ? UIColor(white: 0.4, alpha: 1.0) : UIColor.systemGray4
        line1.layer.cornerRadius = 2
        line1.translatesAutoresizingMaskIntoConstraints = false
        
        let line2 = UIView()
        line2.backgroundColor = isDark ? UIColor(white: 0.35, alpha: 1.0) : UIColor.systemGray5
        line2.layer.cornerRadius = 2
        line2.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(indicator)
        card.addSubview(line1)
        card.addSubview(line2)
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            indicator.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 8),
            indicator.heightAnchor.constraint(equalToConstant: 8),
            
            line1.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 8),
            line1.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: -4),
            line1.widthAnchor.constraint(equalToConstant: 40),
            line1.heightAnchor.constraint(equalToConstant: 4),
            
            line2.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 8),
            line2.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: 4),
            line2.widthAnchor.constraint(equalToConstant: 25),
            line2.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        return card
    }
    
    private func setupModeCard() {
        modeCard.addSubview(modeTitleLabel)
        modeCard.addSubview(modeStackView)
        
        // Create mode buttons
        for (index, mode) in AppearanceMode.allCases.enumerated() {
            let button = AppearanceModeButton(mode: mode)
            button.addTarget(self, action: #selector(modeTapped(_:)), for: .touchUpInside)
            button.tag = index
            modeButtons.append(button)
            modeStackView.addArrangedSubview(button)
            
            // Add separator except for last item
            if index < AppearanceMode.allCases.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                modeStackView.addArrangedSubview(separator)
            }
        }
        
        NSLayoutConstraint.activate([
            modeTitleLabel.topAnchor.constraint(equalTo: modeCard.topAnchor, constant: 16),
            modeTitleLabel.leadingAnchor.constraint(equalTo: modeCard.leadingAnchor, constant: 16),
            modeTitleLabel.trailingAnchor.constraint(equalTo: modeCard.trailingAnchor, constant: -16),
            
            modeStackView.topAnchor.constraint(equalTo: modeTitleLabel.bottomAnchor, constant: 16),
            modeStackView.leadingAnchor.constraint(equalTo: modeCard.leadingAnchor),
            modeStackView.trailingAnchor.constraint(equalTo: modeCard.trailingAnchor),
            modeStackView.bottomAnchor.constraint(equalTo: modeCard.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Actions
    @objc private func modeTapped(_ sender: UIButton) {
        guard let mode = AppearanceMode(rawValue: sender.tag) else { return }
        
        selectedMode = mode
        SettingsManager.shared.appearanceMode = mode
        updateSelection()
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func updateSelection() {
        for button in modeButtons {
            button.setSelected(button.tag == selectedMode.rawValue)
        }
    }
}

// MARK: - Appearance Mode Button
final class AppearanceModeButton: UIButton {
    
    private let mode: AppearanceMode
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodySmall
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLbl: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = Colors.primary
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(mode: AppearanceMode) {
        self.mode = mode
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = UIImage(systemName: mode.icon)
        iconImageView.tintColor = mode == .dark ? .systemPurple : (mode == .light ? .systemOrange : .systemBlue)
        
        titleLbl.text = mode.title
        
        switch mode {
        case .system:
            subtitleLbl.text = "Match device settings"
        case .light:
            subtitleLbl.text = "Always use light mode"
        case .dark:
            subtitleLbl.text = "Always use dark mode"
        }
        
        addSubview(iconImageView)
        addSubview(titleLbl)
        addSubview(subtitleLbl)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLbl.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            subtitleLbl.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            subtitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            subtitleLbl.trailingAnchor.constraint(lessThanOrEqualTo: checkmarkImageView.leadingAnchor, constant: -8),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setSelected(_ selected: Bool) {
        checkmarkImageView.isHidden = !selected
        titleLbl.font = selected ? Fonts.bodyMedium : Fonts.bodySmall
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
            }
        }
    }
}
