//
//  MovieCastView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 13/02/2021.
//

import UIKit

/// View displaying movie cast information.
final class MovieCastView: UIView {

    // MARK: Private properties

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let castLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let titleProvider: (Int) -> String

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - titleProvider: Provides title of the view for a given cast count.
    init(titleProvider: @escaping (Int) -> String) {
        self.titleProvider = titleProvider
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    /// Binds the data to the view.
    /// - Parameters:
    ///   - cast: Object to be bound.
    func bind(cast: [String]) {
        isHidden = cast.isEmpty
        titleLabel.text = titleProvider(cast.count)
        castLabel.text = cast.joined(separator: " • ")
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(contentStackView)
        [
            titleLabel,
            castLabel
        ].forEach(contentStackView.addArrangedSubview)
    }

    private func setupConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
