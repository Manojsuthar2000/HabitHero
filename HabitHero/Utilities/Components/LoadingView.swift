//
//  LoadingView.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow(opacity: 0.2, offset: CGSize(width: 0, height: 4), radius: 12)
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Colors.primary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyMedium
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var message: String? {
        didSet {
            messageLabel.text = message
            messageLabel.isHidden = message == nil
            reUpdateConstraints()
        }
    }
    
    // MARK: - Init
    init(message: String? = nil) {
        self.message = message
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor.black.withAlpha(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(messageLabel)
        
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Container View
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40)
        ])
        
        // Activity Indicator
        if message == nil {
            NSLayoutConstraint.activate([
                activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
            ])
        } else {
            NSLayoutConstraint.activate([
                activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                
                messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
            ])
        }
    }
    
    private func reUpdateConstraints() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(activityIndicator)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.deactivate(containerView.constraints)
        setupConstraints()
    }
    
    // MARK: - Public Methods
    func show(in view: UIView, message: String? = nil) {
        self.message = message
        view.addSubview(self)
        pinToSuperview()
        activityIndicator.startAnimating()
        
        alpha = 0
        fadeIn(duration: 0.2)
    }
    
    func hide(completion: (() -> Void)? = nil) {
        fadeOut(duration: 0.2) {
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
            completion?()
        }
    }
    
    func updateMessage(_ message: String) {
        UIView.animate(withDuration: 0.2) {
            self.message = message
        }
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    
    private static var loadingViewKey: UInt8 = 0
    
    private var loadingView: LoadingView? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView
        }
        set {
            objc_setAssociatedObject(
                self,
                &UIViewController.loadingViewKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// Shows loading indicator in the view controller
    func showLoading(message: String? = nil) {
        hideLoading() // Remove existing if any
        
        let loading = LoadingView(message: message)
        loading.show(in: view, message: message)
        loadingView = loading
    }
    
    /// Hides loading indicator
    func hideLoading(completion: (() -> Void)? = nil) {
        loadingView?.hide {
            self.loadingView = nil
            completion?()
        }
    }
    
    /// Updates loading message
    func updateLoadingMessage(_ message: String) {
        loadingView?.updateMessage(message)
    }
}

// MARK: - Custom Progress View
class ProgressLoadingView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .habitCardBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow(opacity: 0.2, offset: CGSize(width: 0, height: 4), radius: 12)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title3
        label.textColor = .habitTextPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = Colors.primary
        progress.trackTintColor = .habitSecondaryBackground
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodySmall
        label.textColor = .habitTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor.black.withAlpha(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(progressView)
        containerView.addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            percentageLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            percentageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            percentageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            percentageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
        
        updateProgress(0)
    }
    
    // MARK: - Public Methods
    func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
        percentageLabel.text = "\(Int(progress * 100))%"
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        pinToSuperview()
        
        alpha = 0
        fadeIn(duration: 0.2)
    }
    
    func hide(completion: (() -> Void)? = nil) {
        fadeOut(duration: 0.2) {
            self.removeFromSuperview()
            completion?()
        }
    }
}
