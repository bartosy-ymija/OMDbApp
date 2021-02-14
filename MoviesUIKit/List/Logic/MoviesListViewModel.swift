//
//  MoviesListViewModel.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import ResourceKit
import RxCocoa
import RxSwift

/// View model for movies list view controller.
final class MoviesListViewModel {

    // MARK: Properties

    /// State to be rendered on the view controller.
    var state: Observable<MoviesListState> {
        let resourceState = pageResultRelay.compactMap { $0 }
            .map { pageResult -> MoviesListState in
                switch pageResult {
                case let .first(status):
                    switch status {
                    case .loading:
                        return .loading
                    case let .failure(error):
                        return .failure(error)
                    }
                case let .partial(items, status):
                    switch status {
                    case .loading:
                        return .partialLoading(items)
                    case .failure:
                        return .partialFailure(items, .listNotLoaded)
                    case .none:
                        return .partial(items)
                    }
                case let .complete(items):
                    return .complete(items)
                }
            }
        return Observable.merge(resourceState, stateRelay.asObservable())
    }

    // MARK: Private properties

    private let moviesResourceRelay = BehaviorRelay<PagedResource<MovieHeaderRepresentable, MoviesListError>?>(value: nil)

    private let moviesResourceProvider: (String) -> PagedResource<MovieHeaderRepresentable, MoviesListError>

    private let reloadTrigger = PublishRelay<Void>()

    private let nextPageTrigger = PublishRelay<Void>()

    private let searchQuery = PublishRelay<String>()

    private let movieSelected = PublishRelay<MovieHeaderRepresentable>()

    private let pageResultRelay = BehaviorRelay<PagedResult<MovieHeaderRepresentable, MoviesListError>?>(value: nil)

    private let stateRelay = PublishRelay<MoviesListState>()

    private let showMovieDetails: (MovieHeaderRepresentable) -> Void

    private var resourceDisposable: Disposable? = nil

    private let bindingsDisposeBag = DisposeBag()

    private var inputDisposeBag = DisposeBag()

    // MARK: Initializers

    init(
        showMovieDetails: @escaping (MovieHeaderRepresentable) -> Void,
        moviesResourceProvider: @escaping (String) -> PagedResource<MovieHeaderRepresentable, MoviesListError>
    ) {
        self.showMovieDetails = showMovieDetails
        self.moviesResourceProvider = moviesResourceProvider
        setupBindings()
    }

    // MARK: Methods

    func attachInput(
        reloadTrigger: Observable<Void>,
        nextPageTrigger: Observable<Void>,
        searchQuery: Observable<String>,
        movieSelected: Observable<MovieHeaderRepresentable>
    ) {
        inputDisposeBag = DisposeBag()
        reloadTrigger.bind(to: self.reloadTrigger)
            .disposed(by: inputDisposeBag)
        nextPageTrigger.bind(to: self.nextPageTrigger)
            .disposed(by: inputDisposeBag)
        searchQuery.bind(to: self.searchQuery)
            .disposed(by: inputDisposeBag)
        movieSelected.bind(to: self.movieSelected)
            .disposed(by: inputDisposeBag)
    }

    // MARK: Private properties

    private func setupBindings() {
        reloadTrigger
            .bind { [unowned self] _ in
                self.moviesResourceRelay.value?.reset()
                self.moviesResourceRelay.value?.next()
            }
            .disposed(by: bindingsDisposeBag)
        nextPageTrigger
            .filter { [unowned self] _ in
                if case .first(.loading) = self.pageResultRelay.value {
                    return false
                }
                if case .partial(_, .loading) = self.pageResultRelay.value {
                    return false
                }
                return true
            }
            .bind { [unowned self] _ in
                self.moviesResourceRelay.value?.next()
            }
            .disposed(by: bindingsDisposeBag)
        searchQuery
            .filter { !$0.isEmpty }
            .bind { [unowned self] query in
                self.moviesResourceRelay.accept(self.moviesResourceProvider(query))
            }
            .disposed(by: bindingsDisposeBag)
        searchQuery
            .filter { $0.isEmpty }
            .map { _ in
                MoviesListState.failure(MoviesListError.emptyQuery)
            }
            .bind(to: stateRelay)
            .disposed(by: bindingsDisposeBag)
        moviesResourceRelay
            .compactMap { $0 }
            .bind { [unowned self] moviesResource in
                self.resourceDisposable?.dispose()
                self.resourceDisposable = moviesResource.result
                    .bind(to: self.pageResultRelay)
                moviesResource.next()
            }
            .disposed(by: bindingsDisposeBag)
        movieSelected.bind { [unowned self] movie in self.showMovieDetails(movie) }
            .disposed(by: bindingsDisposeBag)
    }
}
