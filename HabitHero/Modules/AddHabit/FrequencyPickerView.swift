//
//  FrequencyPickerView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class FrequencyPickerView: UIView {
    
    // MARK: - Properties
    var onFrequencySelected: ((HabitFrequency) -> Void)?
    private var selectedFrequency: HabitFrequency = .daily {
        didSet {
            updateSelection()
        }
    }
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Frequency"
        label.font = Fonts.labelMedium
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = HabitFrequency.allCases.map { $0.rawValue }
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        
        // Styling
        control.backgroundColor = .habitCardBackground
        control.selectedSegmentTintColor = Colors.primary
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.habitTextPrimary,
            .font: Fonts.bodyMedium
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: Fonts.buttonMedium
        ]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        return control
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        addSubview(titleLabel)
        addSubview(segmentedControl)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        segmentedControl.addTarget(self, action: #selector(frequencyChanged), for: .valueChanged)
        updateDescription()
    }
    
    // MARK: - Actions
    @objc private func frequencyChanged() {
        let index = segmentedControl.selectedSegmentIndex
        if index < HabitFrequency.allCases.count {
            selectedFrequency = HabitFrequency.allCases[index]
        }
    }
    
    private func updateSelection() {
        updateDescription()
        onFrequencySelected?(selectedFrequency)
    }
    
    private func updateDescription() {
        switch selectedFrequency {
        case .daily:
            descriptionLabel.text = "Track this habit every day"
        case .weekly:
            descriptionLabel.text = "Track this habit once per week"
        case .custom:
            descriptionLabel.text = "Set custom days for this habit"
        }
    }
    
    // MARK: - Public Methods
    func setSelectedFrequency(_ frequency: HabitFrequency) {
        selectedFrequency = frequency
        if let index = HabitFrequency.allCases.firstIndex(of: frequency) {
            segmentedControl.selectedSegmentIndex = index
        }
    }
}
