//
//  ProgressRingView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

final class ProgressRingView: UIView {
    
    // MARK: - Properties
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(progressLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    private func setupLayers() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: .pi * 1.5,
            clockwise: true
        )
        
        backgroundLayer.path = path.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray5.cgColor
        backgroundLayer.lineWidth = 20
        backgroundLayer.lineCap = .round
        
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = 20
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    // MARK: - Public Methods
    func updateProgress(completed: Int, total: Int, streak: Int) {
        let percentage = total > 0 ? Float(completed) / Float(total) : 0
        
        progressLabel.text = "\(Int(percentage * 100))%"
        subtitleLabel.text = "🔥 \(streak) day streak"
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        progressLayer.strokeEnd = CGFloat(percentage)
        CATransaction.commit()
    }
}
