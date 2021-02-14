//
//  MoviesListMovieCollectionViewCell.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import UIKit

final class MoviesListMovieCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    static let identifier = "MoviesListMovieCollectionViewCellIdentifier"

    // MARK: Private properties

    private let view = MovieHeaderView()

    // MARK: Initializers

    /// Initalizes the receiver.
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    /// Binds the object to the cell.
    /// - Parameters:
    ///   - movie: Object to be bound.
    func bind(movie: MovieHeaderRepresentable) {
        view.bind(header: movie)
    }
}
