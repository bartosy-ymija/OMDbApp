//
//  PagedResourceSpec.swift
//  ResourceKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import ResourceKit

class PagedResourceSpec: QuickSpec {

    override func spec() {
        describe("paged resource with empty page provider") {
            let provider = pageProvider(items: [.success(PagedResponse(items: [], totalCount: 0))])
            let pagedResource = PagedResource(provider)
            context("when requesting next page") {
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(PagedResult<String, PageError>.self)
                pagedResource.result
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                pagedResource.next()
                it("should return complete with empty items") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .complete([]))
                                ]
                            )
                        )
                }
                pagedResource.next()
                it("should not perform new requests after receiving complete") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .complete([]))
                                ]
                            )
                        )
                }
            }
        }
        describe("paged resource with failing page provider") {
            let provider = pageProvider(
                items: [
                    .failure(.invalidPage)
                ]
            )
            let pagedResource = PagedResource(provider)
            context("when requesting next page") {
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(PagedResult<String, PageError>.self)
                pagedResource.result
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                pagedResource.next()
                it("should return error first page") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .first(.failure(.invalidPage)))
                                ]
                            )
                        )
                }
            }
        }
        describe("paged resource with successful page provider") {
            let provider = pageProvider(
                items: [
                    .success(PagedResponse(items: ["a"], totalCount: 3)),
                    .success(PagedResponse(items: ["b"], totalCount: 3)),
                    .success(PagedResponse(items: ["c"], totalCount: 3))
                ]
            )
            let pagedResource = PagedResource(provider)
            context("when requesting next page") {
                var disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let firstObserver = scheduler.createObserver(PagedResult<String, PageError>.self)
                pagedResource.result
                    .subscribe(firstObserver)
                    .disposed(by: disposeBag)
                pagedResource.next()
                pagedResource.next()
                pagedResource.next()
                it("should return accumulated paginated results") {
                    expect(firstObserver.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .partial(["a"], nil)),
                                    .next(0, .partial(["a"], .loading)),
                                    .next(0, .partial(["a", "b"], nil)),
                                    .next(0, .partial(["a", "b"], .loading)),
                                    .next(0, .complete(["a", "b", "c"]))
                                ]
                            )
                        )
                }
                let secondObserver = scheduler.createObserver(PagedResult<String, PageError>.self)
                disposeBag = DisposeBag()
                pagedResource.reset()
                pagedResource.result
                    .subscribe(secondObserver)
                    .disposed(by: disposeBag)
                pagedResource.next()
                pagedResource.next()
                it("should start from first page after reset") {
                    expect(secondObserver.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .partial(["a"], nil)),
                                    .next(0, .partial(["a"], .loading)),
                                    .next(0, .partial(["a", "b"], nil))
                                ]
                            )
                        )
                }

            }
        }
        describe("paged resource with successful page provider") {
            let provider = pageProvider(
                items: [
                    .success(PagedResponse(items: ["a"], totalCount: 3)),
                    .success(PagedResponse(items: ["b"], totalCount: 3)),
                    .success(PagedResponse(items: ["c"], totalCount: 3))
                ]
            )
            let pagedResource = PagedResource(provider)
            context("when requesting next page") {
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(PagedResult<String, PageError>.self)
                pagedResource.result
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                pagedResource.next()
                pagedResource.next()
                pagedResource.next()
                it("should return complete with empty items") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .partial(["a"], nil)),
                                    .next(0, .partial(["a"], .loading)),
                                    .next(0, .partial(["a", "b"], nil)),
                                    .next(0, .partial(["a", "b"], .loading)),
                                    .next(0, .complete(["a", "b", "c"]))
                                ]
                            )
                        )
                }
            }
        }
        describe("paged resource with mixed page provider") {
            var items: [Result<PagedResponse<String>, PageError>] = [
                .success(PagedResponse(items: ["a"], totalCount: 3)),
                .failure(.invalidPage),
                .success(PagedResponse(items: ["c"], totalCount: 3))
            ]
            let provider: (Int) -> Single<Result<PagedResponse<String>, PageError>> = { page in
                Single.just(items[page])
            }
            let pagedResource = PagedResource(provider)
            context("when requesting next page") {
                let disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(PagedResult<String, PageError>.self)
                pagedResource.result
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                pagedResource.next()
                pagedResource.next()
                items[1] = .success(PagedResponse(items: ["b"], totalCount: 3))
                pagedResource.next()
                pagedResource.next()
                it("should return complete after partial with an error") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .first(.loading)),
                                    .next(0, .partial(["a"], nil)),
                                    .next(0, .partial(["a"], .loading)),
                                    .next(0, .partial(["a"], .failure(.invalidPage))),
                                    .next(0, .partial(["a"], .loading)),
                                    .next(0, .partial(["a", "b"], nil)),
                                    .next(0, .partial(["a", "b"], .loading)),
                                    .next(0, .complete(["a", "b", "c"]))
                                ]
                            )
                        )
                }
            }
        }
    }

    private func pageProvider(items: [Result<PagedResponse<String>, PageError>]) -> (Int) -> Single<Result<PagedResponse<String>, PageError>> {
        { index in
            Single.just(items[index])
        }
    }
}
