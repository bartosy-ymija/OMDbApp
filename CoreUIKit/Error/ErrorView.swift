//
//  ErrorView.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import UIKit

/// View presented when there is an error.
public final class ErrorView: UIView {

    // MARK: Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = configuration.title
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var button: Button = {
        let button = Button()
        button.action = configuration.buttonAction
        button.title = configuration.buttonTitle
        return button
    }()

    private let configuration: Configuration

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   -  configuration: Configuration used to setup this view.
    public init(
        configuration: Configuration
    ) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupHierarchy() {
        [
            titleLabel,
            button
        ].forEach(addSubview)
    }

    private func setupConstraints() {
        [
            titleLabel,
            button
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func didTapButton() {
        configuration.buttonAction()
    }

    // MARK: Structs

    /// Configuration used to setup this view.
    public struct Configuration {
        let title: String
        let buttonTitle: String
        let buttonAction: () -> Void

        public init(title: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
            self.title = title
            self.buttonTitle = buttonTitle
            self.buttonAction = buttonAction
        }
    }
}
