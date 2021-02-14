//
//  ErrorCollectionViewCell.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit

/// Cell presenting an error.
public final class ErrorCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    public static let identifier = "ErrorCollectionViewCellIdentifier"

    private let containerView = UIView()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var button = Button()

    // MARK: Initializers

    /// Initalizes the receiver.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    public func bind(configuration: Configuration) {
        messageLabel.text = configuration.message
        button.title = configuration.buttonTitle
        button.action = configuration.buttonAction
    }

    // MARK: Private methods

    private func setupHierarchy() {
        contentView.addSubview(containerView)
        [
            messageLabel,
            button
        ].forEach(containerView.addSubview)
    }

    private func setupConstraints() {
        [
            containerView,
            messageLabel,
            button
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor),

            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    // MARK: Structs

    public struct Configuration {
        let message: String
        let buttonTitle: String
        let buttonAction: () -> Void

        public init(message: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
            self.message = message
            self.buttonTitle = buttonTitle
            self.buttonAction = buttonAction
        }
    }
}
