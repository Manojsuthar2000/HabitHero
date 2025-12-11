//
//  AnalyticsViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit
import Combine

final class AnalyticsViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: AnalyticsCoordinator?
    private let viewModel: AnalyticsViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Summary Stats Grid
    private let statsGridView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var statCards: [StatCardView] = []
    
    // Weekly Chart
    private let weeklyChartCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let weeklyChartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Progress"
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weeklyChartStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Category Breakdown
    private let categoryCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Top Habits
    private let topHabitsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.addShadow(opacity: 0.1, offset: CGSize(width: 0, height: 2), radius: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topHabitsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Streaks 🔥"
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topHabitsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Empty State
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chart.bar.fill")
        imageView.tintColor = .habitTextTertiary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data Yet"
        label.font = Fonts.title3
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add some habits to start tracking your progress!"
        label.font = Fonts.bodySmall
        label.textColor = .habitTextTertiary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(viewModel: AnalyticsViewModel = AnalyticsViewModel()) {
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
        viewModel.fetchHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHabits()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Analytics"
        view.backgroundColor = .habitBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        view.addSubview(emptyStateView)
        scrollView.addSubview(contentStackView)
        
        // Setup stats grid
        setupStatsGrid()
        
        // Setup weekly chart
        setupWeeklyChart()
        
        // Setup category breakdown
        setupCategoryBreakdown()
        
        // Setup top habits
        setupTopHabits()
        
        // Setup empty state
        setupEmptyState()
        
        // Add to content stack
        contentStackView.addArrangedSubview(statsGridView)
        contentStackView.addArrangedSubview(weeklyChartCard)
        contentStackView.addArrangedSubview(categoryCard)
        contentStackView.addArrangedSubview(topHabitsCard)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupStatsGrid() {
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        topRow.spacing = 12
        topRow.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        
        let totalCard = StatCardView(title: "Total Habits", icon: "list.bullet", color: Colors.primary)
        let completedCard = StatCardView(title: "Done Today", icon: "checkmark.circle.fill", color: .habitSuccess)
        let streakCard = StatCardView(title: "Best Streak", icon: "flame.fill", color: .systemOrange)
        let rateCard = StatCardView(title: "Completion", icon: "percent", color: .systemPurple)
        
        statCards = [totalCard, completedCard, streakCard, rateCard]
        
        topRow.addArrangedSubview(totalCard)
        topRow.addArrangedSubview(completedCard)
        bottomRow.addArrangedSubview(streakCard)
        bottomRow.addArrangedSubview(rateCard)
        
        let mainStack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        statsGridView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: statsGridView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: statsGridView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: statsGridView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: statsGridView.bottomAnchor)
        ])
    }
    
    private func setupWeeklyChart() {
        weeklyChartCard.addSubview(weeklyChartTitleLabel)
        weeklyChartCard.addSubview(weeklyChartStackView)
        
        NSLayoutConstraint.activate([
            weeklyChartTitleLabel.topAnchor.constraint(equalTo: weeklyChartCard.topAnchor, constant: 16),
            weeklyChartTitleLabel.leadingAnchor.constraint(equalTo: weeklyChartCard.leadingAnchor, constant: 16),
            weeklyChartTitleLabel.trailingAnchor.constraint(equalTo: weeklyChartCard.trailingAnchor, constant: -16),
            
            weeklyChartStackView.topAnchor.constraint(equalTo: weeklyChartTitleLabel.bottomAnchor, constant: 20),
            weeklyChartStackView.leadingAnchor.constraint(equalTo: weeklyChartCard.leadingAnchor, constant: 16),
            weeklyChartStackView.trailingAnchor.constraint(equalTo: weeklyChartCard.trailingAnchor, constant: -16),
            weeklyChartStackView.bottomAnchor.constraint(equalTo: weeklyChartCard.bottomAnchor, constant: -16),
            weeklyChartStackView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupCategoryBreakdown() {
        categoryCard.addSubview(categoryTitleLabel)
        categoryCard.addSubview(categoryStackView)
        
        NSLayoutConstraint.activate([
            categoryTitleLabel.topAnchor.constraint(equalTo: categoryCard.topAnchor, constant: 16),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: categoryCard.leadingAnchor, constant: 16),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: categoryCard.trailingAnchor, constant: -16),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 16),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryCard.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryCard.trailingAnchor, constant: -16),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTopHabits() {
        topHabitsCard.addSubview(topHabitsTitleLabel)
        topHabitsCard.addSubview(topHabitsStackView)
        
        NSLayoutConstraint.activate([
            topHabitsTitleLabel.topAnchor.constraint(equalTo: topHabitsCard.topAnchor, constant: 16),
            topHabitsTitleLabel.leadingAnchor.constraint(equalTo: topHabitsCard.leadingAnchor, constant: 16),
            topHabitsTitleLabel.trailingAnchor.constraint(equalTo: topHabitsCard.trailingAnchor, constant: -16),
            
            topHabitsStackView.topAnchor.constraint(equalTo: topHabitsTitleLabel.bottomAnchor, constant: 16),
            topHabitsStackView.leadingAnchor.constraint(equalTo: topHabitsCard.leadingAnchor, constant: 16),
            topHabitsStackView.trailingAnchor.constraint(equalTo: topHabitsCard.trailingAnchor, constant: -16),
            topHabitsStackView.bottomAnchor.constraint(equalTo: topHabitsCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateView.addSubview(emptyIconImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        
        NSLayoutConstraint.activate([
            emptyIconImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyIconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIconImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyIconImageView.bottomAnchor, constant: 16),
            emptyTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 8),
            emptySubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptySubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                self?.updateUI(with: habits)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Update UI
    private func updateUI(with habits: [Habit]) {
        let hasData = !habits.isEmpty
        
        scrollView.isHidden = !hasData
        emptyStateView.isHidden = hasData
        
        guard hasData else { return }
        
        // Update stat cards
        statCards[0].setValue("\(viewModel.totalHabits)")
        statCards[1].setValue("\(viewModel.completedToday)")
        statCards[2].setValue("\(viewModel.bestStreak)")
        statCards[3].setValue("\(viewModel.completionRate)%")
        
        // Update weekly chart
        updateWeeklyChart()
        
        // Update category breakdown
        updateCategoryBreakdown()
        
        // Update top habits
        updateTopHabits()
    }
    
    private func updateWeeklyChart() {
        weeklyChartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let weeklyData = viewModel.weeklyData
        let maxRate = weeklyData.map { $0.completionRate }.max() ?? 1.0
        
        for dayData in weeklyData {
            let barView = WeeklyBarView(
                dayName: dayData.dayName,
                completionRate: dayData.completionRate,
                maxRate: max(maxRate, 0.01),
                isToday: dayData.isToday
            )
            weeklyChartStackView.addArrangedSubview(barView)
        }
    }
    
    private func updateCategoryBreakdown() {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for stat in viewModel.categoryStats {
            let row = CategoryProgressRow(stat: stat)
            categoryStackView.addArrangedSubview(row)
        }
        
        if viewModel.categoryStats.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No categories yet"
            emptyLabel.font = Fonts.bodySmall
            emptyLabel.textColor = .habitTextTertiary
            emptyLabel.textAlignment = .center
            categoryStackView.addArrangedSubview(emptyLabel)
        }
    }
    
    private func updateTopHabits() {
        topHabitsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, habit) in viewModel.topHabits.enumerated() {
            let row = TopHabitRow(habit: habit, rank: index + 1)
            topHabitsStackView.addArrangedSubview(row)
        }
        
        if viewModel.topHabits.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Complete habits to build streaks!"
            emptyLabel.font = Fonts.bodySmall
            emptyLabel.textColor = .habitTextTertiary
            emptyLabel.textAlignment = .center
            topHabitsStackView.addArrangedSubview(emptyLabel)
        }
    }
}

// MARK: - Stat Card View
final class StatCardView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.displayMedium
        label.textColor = .habitTextPrimary
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption1
        label.textColor = .habitTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, icon: String, color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = .habitCardBackground
        layer.cornerRadius = 12
        addShadow(opacity: 0.08, offset: CGSize(width: 0, height: 2), radius: 6)
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = color
        
        addSubview(iconImageView)
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

// MARK: - Weekly Bar View
final class WeeklyBarView: UIView {
    
    private let barContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitSecondaryBackground
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let barFillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption2
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption2
        label.textColor = .habitTextTertiary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var fillHeightConstraint: NSLayoutConstraint!
    
    init(dayName: String, completionRate: Double, maxRate: Double, isToday: Bool) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.text = dayName
        percentLabel.text = "\(Int(completionRate * 100))%"
        
        if isToday {
            dayLabel.font = Fonts.caption1
            dayLabel.textColor = Colors.primary
            barFillView.backgroundColor = Colors.primary
        } else {
            barFillView.backgroundColor = Colors.primary.withAlphaComponent(0.5)
        }
        
        addSubview(percentLabel)
        addSubview(barContainerView)
        addSubview(dayLabel)
        barContainerView.addSubview(barFillView)
        
        let fillHeight = max(completionRate / max(maxRate, 0.01), 0.05) * 80
        fillHeightConstraint = barFillView.heightAnchor.constraint(equalToConstant: fillHeight)
        
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: topAnchor),
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            barContainerView.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 4),
            barContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barContainerView.widthAnchor.constraint(equalToConstant: 24),
            barContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            barFillView.leadingAnchor.constraint(equalTo: barContainerView.leadingAnchor),
            barFillView.trailingAnchor.constraint(equalTo: barContainerView.trailingAnchor),
            barFillView.bottomAnchor.constraint(equalTo: barContainerView.bottomAnchor),
            fillHeightConstraint,
            
            dayLabel.topAnchor.constraint(equalTo: barContainerView.bottomAnchor, constant: 8),
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Category Progress Row
final class CategoryProgressRow: UIView {
    
    init(stat: CategoryStat) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: stat.category.icon)
        iconView.tintColor = stat.category.color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = stat.category.rawValue
        nameLabel.font = Fonts.bodyMedium
        nameLabel.textColor = .habitTextPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let countLabel = UILabel()
        countLabel.text = "\(stat.completedToday)/\(stat.totalHabits)"
        countLabel.font = Fonts.caption1
        countLabel.textColor = .habitTextSecondary
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let progressBackground = UIView()
        progressBackground.backgroundColor = .habitSecondaryBackground
        progressBackground.layer.cornerRadius = 3
        progressBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let progressFill = UIView()
        progressFill.backgroundColor = stat.category.color
        progressFill.layer.cornerRadius = 3
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(countLabel)
        addSubview(progressBackground)
        progressBackground.addSubview(progressFill)
        
        let fillWidth = stat.completionRate
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            progressBackground.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            progressBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBackground.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            progressBackground.heightAnchor.constraint(equalToConstant: 6),
            
            progressFill.leadingAnchor.constraint(equalTo: progressBackground.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressBackground.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressBackground.bottomAnchor),
            progressFill.widthAnchor.constraint(equalTo: progressBackground.widthAnchor, multiplier: max(fillWidth, 0.02))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Top Habit Row
final class TopHabitRow: UIView {
    
    init(habit: Habit, rank: Int) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .habitSecondaryBackground
        layer.cornerRadius = 10
        
        let rankLabel = UILabel()
        rankLabel.text = "#\(rank)"
        rankLabel.font = Fonts.labelMedium
        rankLabel.textColor = rank <= 3 ? Colors.primary : .habitTextTertiary
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: habit.category.icon)
        iconView.tintColor = habit.category.color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = habit.title
        nameLabel.font = Fonts.bodyMedium
        nameLabel.textColor = .habitTextPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let streakLabel = UILabel()
        streakLabel.text = "🔥 \(habit.streak)"
        streakLabel.font = Fonts.bodyMedium
        streakLabel.textColor = .systemOrange
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(rankLabel)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(streakLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 30),
            
            iconView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: streakLabel.leadingAnchor, constant: -8),
            
            streakLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            streakLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
