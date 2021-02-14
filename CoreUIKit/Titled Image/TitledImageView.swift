//
//  TitledImageView.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import UIKit

/// View presenting image with a title.
public final class TitledImageView: UIView {

    // MARK: Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = configuration.title
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView = UIImageView(image: configuration.image)

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
            imageView,
            titleLabel
        ].forEach(addSubview)
    }

    private func setupConstraints() {
        [
            imageView,
            titleLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: Structs

    /// Configuration used to setup this view.
    public struct Configuration {
        let title: String
        let image: UIImage

        public init(title: String, image: UIImage) {
            self.title = title
            self.image = image
        }
    }
}
