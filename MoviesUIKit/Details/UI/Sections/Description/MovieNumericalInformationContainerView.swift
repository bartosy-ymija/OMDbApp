//
//  MovieNumericalInformationContainerView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit
import CoreUIKit
import RxCocoa
import RxSwift
import RxDataSources

/// View containing numerical information.
final class MovieNumericalInformationContainerView: UIView {

    // MARK: Private properties

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let contentViews: [InformationType: MovieNumericalInformationView] = {
        let views = InformationType.orderedTypes.map { MovieNumericalInformationView(icon: $0.icon) }
        return Dictionary(zip(InformationType.orderedTypes, views)) { key, _ in key }
    }()

    // MARK: Initializers

    /// Initializes the receiver.
    init() {
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
        InformationType.orderedTypes
            .compactMap { contentViews[$0] }
            .forEach(contentStackView.addArrangedSubview)
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

    func bind(value: String, for type: InformationType) {
        contentViews[type]?.isHidden = value.isEmpty
        contentViews[type]?.value = value
    }

    // MARK: Enums

    enum InformationType {
        case score
        case runtime
        case reviews

        static let orderedTypes: [InformationType] = [
            .score, .runtime, .reviews
        ]

        var icon: UIImage {
            switch self {
            case .score:
                guard let image = UIImage(named: "Score", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
                  fatalError("Missing score image.")
                }
                return image
            case .runtime:
                guard let image = UIImage(named: "Runtime", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
                  fatalError("Missing runtime image.")
                }
                return image
            case .reviews:
                guard let image = UIImage(named: "Reviews", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
                  fatalError("Missing reviews image.")
                }
                return image
            }
        }
    }
}
