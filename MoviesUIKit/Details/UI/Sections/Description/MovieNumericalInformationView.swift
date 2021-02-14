//
//  MovieNumericalInformationView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit
import CoreUIKit
import RxCocoa
import RxSwift
import RxDataSources

/// View numerical information about the movie.
final class MovieNumericalInformationView: UIView {

    // MARK: Properties

    /// Value to be displayed in this view.
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }

    // MARK: Private properties

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 8, left: 0, bottom: 0, right: 0)
        stackView.spacing = 4
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: icon)
        imageView.tintColor = .black
        return imageView
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .semibold)
        return label
    }()

    private let icon: UIImage

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - icon: Icon to be displayed in this view.
    init(icon: UIImage) {
        self.icon = icon
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(contentStackView)
        [
            iconImageView,
            valueLabel
        ].forEach(contentStackView.addArrangedSubview)
    }

    private func setupConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
