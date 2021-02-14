//
//  MovieDetailsViewModelSpec.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 14/02/2021.
//

import Quick
import Nimble
import RxSwift
import RxTest
import ResourceKit
@testable import MoviesKit
@testable import MoviesUIKit

final class MovieDetailsViewModelSpec: QuickSpec {

    private static let fixtureMovieDetails = MockDetailsRepresentable()
    private static let fixtureMovieHeader = MockHeaderRepresentable(title: "")

    override func spec() {
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MovieDetailsState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: []
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("after init") {
                scheduler.start()
                it("should emit header state") {
                    expect(observer.events.first?.value.element?.header.id)
                        .to(equal(MovieDetailsViewModelSpec.fixtureMovieHeader.id))
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MovieDetailsState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                reloadEvents: [.next(0, ())]
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("on reload with successful value") {
                scheduler.start()
                it("should emit complete state with details") {
                    expect(observer.events.last?.value.element?.details?.formattedPlot)
                        .to(equal(MovieDetailsViewModelSpec.fixtureMovieDetails.formattedPlot))
                }
            }
        }
        describe("movies list view model") {
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let observer = scheduler.createObserver(MovieDetailsState.self)
            let viewModel = mockViewModel(
                scheduler: scheduler,
                movieDetails: .failure(.detailsNotLoaded),
                reloadEvents: [.next(0, ())]
            )
            viewModel.state
                .bind(to: observer)
                .disposed(by: disposeBag)
            context("on reload with an error") {
                scheduler.start()
                it("should emit failure state") {
                    expect(observer.events.last?.value.element?.isFailure)
                        .to(be(true))
                }
            }
        }
    }

    private func mockViewModel(
        scheduler: TestScheduler,
        movieDetails: Result<MovieDetailsRepresentable, MovieDetailsError> = .success(fixtureMovieDetails),
        movieHeader: MovieHeaderRepresentable = fixtureMovieHeader,
        reloadEvents: [Recorded<Event<Void>>]
    ) -> MovieDetailsViewModel {
        let movieDetailsResource = Resource {
            Single.just(movieDetails)
        }
        let viewModel = MovieDetailsViewModel(
            movieHeader: movieHeader,
            movieDetailsResource: movieDetailsResource
        )
        let reloadEventsObservable = scheduler.createHotObservable(reloadEvents)
        viewModel.attachInput(
            reloadTrigger: reloadEventsObservable.asObservable()
        )
        return viewModel
    }
}

private extension MovieDetailsState {
    var details: MovieDetailsRepresentable? {
        switch self {
        case let .complete(_, details):
            return details
        default:
            return nil
        }
    }

    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}
