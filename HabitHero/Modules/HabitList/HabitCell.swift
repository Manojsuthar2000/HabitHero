//
//  HabitCell.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class HabitCell: UITableViewCell {
    
    static let identifier = "HabitCell"
    
    // MARK: - Properties
    var onToggleCompletion: (() -> Void)?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(streakLabel)
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 30),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: streakLabel.leadingAnchor, constant: -8),
            
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            streakLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            streakLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configure
    func configure(with habit: Habit) {
        titleLabel.text = habit.title
        categoryLabel.text = habit.category.rawValue
        checkButton.isSelected = habit.isCompleted
        checkButton.tintColor = habit.isCompleted ? .systemGreen : .systemGray3
        
        if habit.streak > 0 {
            streakLabel.text = "🔥 \(habit.streak)"
            streakLabel.isHidden = false
        } else {
            streakLabel.isHidden = true
        }
    }
    
    @objc private func checkButtonTapped() {
        onToggleCompletion?()
    }
}

