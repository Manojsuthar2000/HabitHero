//
//  CategoryPickerView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class CategoryPickerView: UIView {
    
    // MARK: - Properties
    var onCategorySelected: ((HabitCategory) -> Void)?
    private var selectedCategory: HabitCategory = .other {
        didSet {
            updateSelection()
        }
    }
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = Fonts.labelMedium
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let categories = HabitCategory.allCases
    
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
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 90),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func setSelectedCategory(_ category: HabitCategory) {
        selectedCategory = category
    }
    
    private func updateSelection() {
        collectionView.reloadData()
        onCategorySelected?(selectedCategory)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.identifier,
            for: indexPath
        ) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 90)
    }
}

// MARK: - Category Cell
class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .habitTextSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure
    func configure(with category: HabitCategory, isSelected: Bool) {
        iconImageView.image = UIImage(systemName: category.icon)
        titleLabel.text = category.rawValue
        
        if isSelected {
            containerView.backgroundColor = category.color.withAlpha(0.15)
            containerView.layer.borderColor = category.color.cgColor
            iconImageView.tintColor = category.color
            titleLabel.textColor = category.color
            titleLabel.font = Fonts.labelMedium
            
            // Animate selection
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        } else {
            containerView.backgroundColor = .habitCardBackground
            containerView.layer.borderColor = UIColor.clear.cgColor
            iconImageView.tintColor = .habitTextSecondary
            titleLabel.textColor = .habitTextSecondary
            titleLabel.font = Fonts.caption1
            
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
}
