//
//  MoviesListViewModelSpec.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Quick
import Nimble
import RxSwift
import RxTest
import ResourceKit
@testable import MoviesUIKit

final class MoviesListViewModelSpec: QuickSpec {

    private let fixtureQuery = "query"

    override func spec() {
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [],
                searchQueryEvents: [.next(0, fixtureQuery)],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when searching") {
                scheduler.start()
                it("should load first page") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .loading),
                                    .next(0, .partial([MockHeaderRepresentable(title: self.fixtureQuery)]))
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [],
                searchQueryEvents: [.next(0, "")],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when searching for an empty query") {
                scheduler.start()
                it("should return an empty query error") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .failure(.emptyQuery))
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [.next(1, ())],
                searchQueryEvents: [.next(0, fixtureQuery)],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when searching and reaching end") {
                scheduler.start()
                it("should load two pages") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .loading),
                                    .next(0, .partial([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partialLoading([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partial([MockHeaderRepresentable(title: self.fixtureQuery), MockHeaderRepresentable(title: self.fixtureQuery)]))
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [.next(1, ())],
                searchQueryEvents: [.next(0, "\(fixtureQuery)\(fixtureQuery)"), .next(2, fixtureQuery)],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when searching and changing query") {
                scheduler.start()
                it("should load new query page") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .loading),
                                    .next(0, .partial([MockHeaderRepresentable(title: "")])),
                                    .next(1, .partialLoading([MockHeaderRepresentable(title: "")])),
                                    .next(1, .partial([MockHeaderRepresentable(title: ""), MockHeaderRepresentable(title: "")])),
                                    .next(2, .loading),
                                    .next(2, .partial([MockHeaderRepresentable(title: self.fixtureQuery)]))
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [.next(2, ())],
                nextPageEvents: [.next(1, ())],
                searchQueryEvents: [.next(0, fixtureQuery)],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when searching and reloading") {
                scheduler.start()
                it("should reload first page") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .loading),
                                    .next(0, .partial([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partialLoading([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partial([MockHeaderRepresentable(title: self.fixtureQuery), MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(2, .loading),
                                    .next(2, .partial([MockHeaderRepresentable(title: self.fixtureQuery)]))
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [.next(1, ()), .next(2, ()), .next(3, ())],
                searchQueryEvents: [.next(0, fixtureQuery)],
                movieSelectedEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when reaching end page") {
                scheduler.start()
                it("should not load new items") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .loading),
                                    .next(0, .partial([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partialLoading([MockHeaderRepresentable(title: self.fixtureQuery)])),
                                    .next(1, .partial(
                                            [
                                                MockHeaderRepresentable(title: self.fixtureQuery),
                                                MockHeaderRepresentable(title: self.fixtureQuery)
                                            ]
                                    )),
                                    .next(2, .partialLoading(
                                            [
                                                MockHeaderRepresentable(title: self.fixtureQuery),
                                                MockHeaderRepresentable(title: self.fixtureQuery)
                                            ]
                                    )),
                                    .next(2, .complete(
                                            [
                                                MockHeaderRepresentable(title: self.fixtureQuery),
                                                MockHeaderRepresentable(title: self.fixtureQuery),
                                                MockHeaderRepresentable(title: self.fixtureQuery)
                                            ]
                                    )),
                                ]
                            )
                        )
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MoviesListState.self)
            let expectedMovie = MockHeaderRepresentable(title: self.fixtureQuery)
            var shownMovie: MovieHeaderRepresentable? = nil
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [],
                nextPageEvents: [],
                searchQueryEvents: [],
                movieSelectedEvents: [.next(0, expectedMovie)],
                showMovieDetails: { shownMovie = $0 }
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("when selecting movie") {
                scheduler.start()
                it("should display that movie") {
                    expect(shownMovie?.id).toEventually(equal(expectedMovie.id))
                }
            }
        }
    }

    private func mockViewModel(
        scheduler: TestScheduler,
        reloadEvents: [Recorded<Event<Void>>],
        nextPageEvents: [Recorded<Event<Void>>],
        searchQueryEvents: [Recorded<Event<String>>],
        movieSelectedEvents: [Recorded<Event<MovieHeaderRepresentable>>],
        showMovieDetails: @escaping (MovieHeaderRepresentable) -> Void = { _ in }
    ) -> MoviesListViewModel {
        let reloadEventsObservable = scheduler.createHotObservable(reloadEvents)
        let nextPageEventsObservable = scheduler.createHotObservable(nextPageEvents)
        let searchQueryEventsObservable = scheduler.createHotObservable(searchQueryEvents)
        let movieSelectedEventsObservable = scheduler.createHotObservable(movieSelectedEvents)
        let provider = { query in
            self.pageProvider(
                items: [
                    .success(PagedResponse(items: [MockHeaderRepresentable(title: query)], totalCount: 3)),
                    .success(PagedResponse(items: [MockHeaderRepresentable(title: query)], totalCount: 3)),
                    .success(PagedResponse(items: [MockHeaderRepresentable(title: query)], totalCount: 3))
                ]
            )
        }
        let pagedResource = { query in
            PagedResource(provider(query))
        }
        let viewModel = MoviesListViewModel(
            showMovieDetails: showMovieDetails,
            moviesResourceProvider: pagedResource
        )
        viewModel.attachInput(
            reloadTrigger: reloadEventsObservable.asObservable(),
            nextPageTrigger: nextPageEventsObservable.asObservable(),
            searchQuery: searchQueryEventsObservable.asObservable(),
            movieSelected: movieSelectedEventsObservable.asObservable()
        )
        return viewModel
    }

    private func pageProvider(items: [Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>]) -> ((Int) -> Single<Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>>) {
        { index in
            Single.just(items[index])
        }
    }
}
