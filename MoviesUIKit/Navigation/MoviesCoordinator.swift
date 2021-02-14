//
//  MoviesCoordinator.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import UIKit

public final class MoviesCoordinator {

    // MARK: Private properties

    private weak var navigationController: UINavigationController?

    private let moviesAssembly = MoviesAssembly()

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - navigationController: Navigation controller to which the flow should be attached.
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: Methods

    public func showMoviesListScreen() {
        let viewController = moviesAssembly.moviesListViewController { [unowned self] movie in showMovieDetailsScreen(movie: movie)
        }
        navigationController?.viewControllers = [viewController]
    }

    private func showMovieDetailsScreen(movie: MovieHeaderRepresentable) {
        let viewController = moviesAssembly.movieDetailsViewController(movie: movie)
        navigationController?.present(viewController, animated: true)
    }
}
