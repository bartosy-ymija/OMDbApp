//
//  MovieDetailsViewModel.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import ResourceKit
import RxCocoa
import RxSwift

/// View model for movie details view controller.
final class MovieDetailsViewModel {

    // MARK: Properties

    /// Emits state to be rendered on the screen.
    var state: Observable<MovieDetailsState> {
        stateRelay
            .compactMap { $0 }
            .asObservable()
    }

    // MARK: Private properties

    private let stateRelay: BehaviorRelay<MovieDetailsState>

    private let movieDetailsResource: Resource<MovieDetailsRepresentable, MovieDetailsError>

    private let reloadTrigger = PublishRelay<Void>()

    private var inputDisposeBag = DisposeBag()

    private let bindingsDisposeBag = DisposeBag()

    // MARK: Initializers

    init(movieHeader: MovieHeaderRepresentable, movieDetailsResource: Resource<MovieDetailsRepresentable, MovieDetailsError>) {
        stateRelay = BehaviorRelay<MovieDetailsState>(value: .header(movieHeader))
        self.movieDetailsResource = movieDetailsResource
        setupBindings()
    }

    // MARK: Methods

    func attachInput(reloadTrigger: Observable<Void>) {
        inputDisposeBag = DisposeBag()
        reloadTrigger.bind(to: self.reloadTrigger)
            .disposed(by: inputDisposeBag)
    }

    // MARK: Private methods

    private func setupBindings() {
        reloadTrigger
            .flatMapLatest { [unowned self] in
                self.movieDetailsResource.resolve()
            }
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case let .success(details):
                    self.stateRelay.accept(.complete(self.stateRelay.value.header, details))
                case .failure:
                    self.stateRelay.accept(.failure(self.stateRelay.value.header))
                }
            })
            .disposed(by: bindingsDisposeBag)
    }
}
