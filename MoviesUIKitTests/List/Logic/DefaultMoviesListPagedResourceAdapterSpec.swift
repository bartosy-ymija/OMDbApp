//
//  DefaultMoviesListPagedResourceAdapterSpec.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import ResourceKit
@testable import MoviesKit
@testable import MoviesUIKit

final class DefaultMoviesListPagedResourceAdapterSpec: QuickSpec {

    private let fixtureSearchItem = MoviesSearchItemResponse(
        title: "fixtureTitle",
        id: "fixtureId",
        imagePath: "imagePath",
        year: "year"
    )

    private let fixtureSearchCount = "3"

    override func spec() {
        describe("default adapter") {
            let adapter = DefaultMoviesListPagedResourceAdapter()
            context("when converting data source returning items") {
                let dataSource = Single<Result<MoviesSearchResponse, MoviesError>>.just(
                    .success(
                        MoviesSearchResponse(
                            totalCount: fixtureSearchCount,
                            items: [fixtureSearchItem],
                            error: nil
                        )
                    )
                )
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>.self)
                adapter.convert(dataSource: dataSource)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should convert it to a paged response containing items") {
                    expect(observer.events.first?.value.element?.value?.items.map { $0.id })
                        .to(equal([self.fixtureSearchItem.id]))
                }
                it("should convert it to a paged response with a proper total count") {
                    expect(observer.events.first?.value.element?.value?.totalCount)
                        .to(equal(Int(self.fixtureSearchCount)))
                }
            }
            context("when converting data source returning imdb id internal error") {
                let dataSource = Single<Result<MoviesSearchResponse, MoviesError>>.just(
                    .success(
                        MoviesSearchResponse(
                            totalCount: nil,
                            items: nil,
                            error: MoviesSearchResponse.invalidIdErrorMessage
                        )
                    )
                )
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>.self)
                adapter.convert(dataSource: dataSource)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return too many results error") {
                    expect(observer.events.first?.value.element?.error)
                        .to(equal(.tooManyResults))
                }
            }
            context("when converting data source returning too many results internal error") {
                let dataSource = Single<Result<MoviesSearchResponse, MoviesError>>.just(
                    .success(
                        MoviesSearchResponse(
                            totalCount: nil,
                            items: nil,
                            error: MoviesSearchResponse.invalidIdErrorMessage
                        )
                    )
                )
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>.self)
                adapter.convert(dataSource: dataSource)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return too many results error") {
                    expect(observer.events.first?.value.element?.error)
                        .to(equal(.tooManyResults))
                }
            }
            context("when converting data source returning unrecognized internal error") {
                let dataSource = Single<Result<MoviesSearchResponse, MoviesError>>.just(
                    .success(
                        MoviesSearchResponse(
                            totalCount: nil,
                            items: nil,
                            error: "invalid"
                        )
                    )
                )
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>.self)
                adapter.convert(dataSource: dataSource)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return paged response with empty items") {
                    expect(observer.events.first?.value.element?.value?.items.map { $0.id })
                        .to(equal([]))
                }
            }
            context("when converting data source returning api error") {
                let dataSource = Single<Result<MoviesSearchResponse, MoviesError>>.just(
                    .failure(.apiError)
                )
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>.self)
                adapter.convert(dataSource: dataSource)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return list not loaded error") {
                    expect(observer.events.first?.value.element?.error)
                        .to(equal(.listNotLoaded))
                }
            }
        }
    }
}

private extension Result {
    var value: Success? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
