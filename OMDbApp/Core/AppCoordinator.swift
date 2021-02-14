//
//  AppCoordinator.swift
//  OMDbApp
//
//  Created by Bartosz Żmija on 11/02/2021.
//

import MoviesUIKit
import UIKit

final class AppCoordinator {

    // MARK: Private properties

    private weak var navigationController: UINavigationController?

    private lazy var moviesCoordinator = MoviesCoordinator(navigationController: navigationController)

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - navigationController: Navigation controller to which the flow should be attached.
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Methods

    func start() {
        moviesCoordinator.showMoviesListScreen()
    }
}
