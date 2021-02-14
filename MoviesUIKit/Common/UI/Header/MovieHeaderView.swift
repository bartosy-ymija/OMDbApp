//
//  MovieHeaderView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import UIKit
import Kingfisher

final class MovieHeaderView: UIView {

    // MARK: Private properties

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: configuration.titleFontSize, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: configuration.yearFontSize, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let gradientLayer = CAGradientLayer()

    private lazy var labelContainerView: UIView = {
        let view = UIView()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = .init(x: 0.5, y: 1)
        gradientLayer.endPoint = .init(x: 0.5, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()

    private let placeholderImage: UIImage = {
        guard let image = UIImage(named: "Placeholder", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
          fatalError("Missing placeholder image.")
        }
        return image
    }()

    private let configuration: Configuration

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - configuration: Object describing how to configure this view.
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    func bind(header: MovieHeaderRepresentable) {
        yearLabel.text = header.year
        titleLabel.text = header.title
        posterImageView.kf.setImage(with: URL(string: header.imagePath), placeholder: placeholderImage)
    }

    // MARK: Private methods

    private func setupHierarchy() {
        [
            posterImageView,
            labelContainerView
        ].forEach(addSubview)
        [
            titleLabel,
            yearLabel
        ].forEach(labelContainerView.addSubview)
    }

    private func setupConstraints() {
        [
            posterImageView,
            labelContainerView,
            titleLabel,
            yearLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            labelContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),

            yearLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 8),
            yearLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: yearLabel.topAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = labelContainerView.bounds
    }

    // MARK: Structs

    struct Configuration {
        let titleFontSize: CGFloat
        let yearFontSize: CGFloat

        static let `default` = Configuration(
            titleFontSize: 16,
            yearFontSize: 12
        )
    }
}
