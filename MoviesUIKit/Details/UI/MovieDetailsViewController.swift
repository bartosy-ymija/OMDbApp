//
//  MovieDetailsViewController.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

/// View controller displaying details of a movie.
final class MovieDetailsViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: MovieDetailsViewModel

    private let customView = MovieDetailsView()

    private let disposeBag = DisposeBag()

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - viewModel: View model associated with this view controller.
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        customView.rx.closeTrigger
            .bind { [unowned self] in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        viewModel.state
            .bind(to: customView.rx.state)
            .disposed(by: disposeBag)
        viewModel.attachInput(
            reloadTrigger: customView.rx.reloadTrigger.startWith(())
        )
    }

    override func loadView() {
        self.view = customView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
