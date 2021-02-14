//
//  MovieDescriptionView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit
import CoreUIKit
import RxCocoa
import RxSwift
import RxDataSources

/// View displaying movie description information.
final class MovieDescriptionView: UIView {

    // MARK: Private properties

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let plotLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let numericalInformationContainer = MovieNumericalInformationContainerView()

    // MARK: Initializers

    /// Initializes the receiver.
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    func bind(description: MovieDescriptionRepresentable) {
        categoriesLabel.isHidden = description.splitGenre.isEmpty
        categoriesLabel.text = description.splitGenre.joined(separator: " • ")
        plotLabel.text = description.formattedPlot
        numericalInformationContainer.bind(value: description.formattedScore, for: .score)
        numericalInformationContainer.bind(value: description.formattedRuntime, for: .runtime)
        numericalInformationContainer.bind(value: description.formattedReviews, for: .reviews)
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(contentStackView)
        [
            categoriesLabel,
            plotLabel,
            numericalInformationContainer
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
