//
//  MoviesListViewController.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

/// View controller displaying a list of movies.
final class MoviesListViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: MoviesListViewModel

    private let customView = MoviesListView()

    private let disposeBag = DisposeBag()

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - viewModel: View model associated with this view controller.
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state
            .bind(to: customView.rx.state)
            .disposed(by: disposeBag)
        viewModel.attachInput(
            reloadTrigger: customView.rx.reloadTrigger
                .startWith(()),
            nextPageTrigger: customView.rx.nextPageTrigger,
            searchQuery: customView.rx.searchQuery
                .debounce(.milliseconds(50), scheduler: MainScheduler.instance),
            movieSelected: customView.rx.movieSelected
        )
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func loadView() {
        self.view = customView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
