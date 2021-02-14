//
//  MovieCastContainerView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 13/02/2021.
//

import UIKit

/// View grouping information about a movie cast.
final class MovieCastContainerView: UIView {

    // MARK: Private properties

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let contentViews: [CastType: MovieCastView] = {
        let views = CastType.orderedTypes.map { MovieCastView(titleProvider: $0.titleProvider) }
        return Dictionary(zip(CastType.orderedTypes, views)) { key, _ in key }
    }()

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

    func bind(cast: MovieCastRepresentable) {
        contentViews[.actors]?.bind(cast: cast.splitActors)
        contentViews[.directors]?.bind(cast: cast.splitDirectors)
        contentViews[.writers]?.bind(cast: cast.splitWriters)
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(contentStackView)
        CastType.orderedTypes.compactMap { contentViews[$0] }.forEach(contentStackView.addArrangedSubview)
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

    enum CastType {
        case directors, writers, actors

        static let orderedTypes: [CastType] = [.directors, .writers, .actors]

        var titleProvider: (Int) -> String {
            switch self {
            case .actors:
                return { count in
                    count == 1 ? "Actor" : "Actors"
                }
            case .directors:
                return { count in
                    count == 1 ? "Director" : "Directors"
                }
            case .writers:
                return { count in
                    count == 1 ? "Writer" : "Writers"
                }
            }
        }
    }
}
