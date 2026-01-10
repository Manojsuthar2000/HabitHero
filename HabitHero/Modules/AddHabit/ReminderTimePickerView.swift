//
//  ReminderTimePickerView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class ReminderTimePickerView: UIView {
    
    // MARK: - Properties
    var onReminderToggled: ((Bool) -> Void)?
    var onTimeChanged: ((Date) -> Void)?
    
    private var isReminderEnabled: Bool = false {
        didSet {
            updateReminderState()
        }
    }
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder"
        label.font = Fonts.bodyMedium
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get notified to build your habit"
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = Colors.primary
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.alpha = 0
        picker.isHidden = true
        return picker
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    private var datePickerHeightConstraint: NSLayoutConstraint?
    
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
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(toggleSwitch)
        containerView.addSubview(separatorView)
        containerView.addSubview(datePicker)
        
        datePickerHeightConstraint = datePicker.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            separatorView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            datePicker.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePickerHeightConstraint!,
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        toggleSwitch.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func toggleChanged() {
        isReminderEnabled = toggleSwitch.isOn
        onReminderToggled?(isReminderEnabled)
    }
    
    @objc private func timeChanged() {
        onTimeChanged?(datePicker.date)
    }
    
    private func updateReminderState() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.isReminderEnabled {
                self.separatorView.isHidden = false
                self.datePicker.isHidden = false
                self.separatorView.alpha = 1
                self.datePicker.alpha = 1
                self.datePickerHeightConstraint?.constant = 200
            } else {
                self.separatorView.alpha = 0
                self.datePicker.alpha = 0
                self.datePickerHeightConstraint?.constant = 0
            }
            self.layoutIfNeeded()
        }) { _ in
            if !self.isReminderEnabled {
                self.separatorView.isHidden = true
                self.datePicker.isHidden = true
            }
        }
    }
    
    // MARK: - Public Methods
    func setReminderEnabled(_ enabled: Bool) {
        toggleSwitch.isOn = enabled
        isReminderEnabled = enabled
    }
    
    func setReminderTime(_ time: Date) {
        datePicker.date = time
    }
    
    func getReminderTime() -> Date {
        return datePicker.date
    }
    
    func reset() {
        toggleSwitch.isOn = false
        isReminderEnabled = false
        datePicker.date = Date()
    }
}
