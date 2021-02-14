//
//  PagedResource.swift
//  ResourceKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import RxSwift
import RxRelay

public final class PagedResource<Success, Failure: Error> {

    // MARK: Properties

    /// Emits accumulated paged results.
    public var result: Observable<PagedResult<Success, Failure>> {
        resultRelay.compactMap { $0 }
    }

    // MARK: Private properties

    private var currentPage = 0

    private let pageProvider: (Int) -> Single<Result<PagedResponse<Success>, Failure>>

    private let resultRelay = BehaviorRelay<PagedResult<Success, Failure>?>(value: nil)

    private let triggerRelay = PublishRelay<Void>()

    private var disposeBag = DisposeBag()

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - pageProvider: Provides items for a given page.
    public convenience init(_ pageProvider: @escaping (Int) -> Single<Result<PagedResponse<Success>, Failure>>) {
        self.init(pageProvider, transform: { $0 }, errorTransform: { $0 })
    }

    private init<SourceSuccess, SourceFailure: Error>(
        _ pageProvider: @escaping (Int) -> Single<Result<PagedResponse<SourceSuccess>, SourceFailure>>,
        transform: @escaping (SourceSuccess) -> Success,
        errorTransform: @escaping (SourceFailure) -> Failure
    ) {
        self.pageProvider = { page in
            pageProvider(page)
                .map { $0.map { $0.map(transform) } }
                .map { $0.mapError(errorTransform) }

        }
        setupBindings()
    }

    // MARK: Methods

    /// Triggers the next page load.
    public func next() {
        if case .complete = resultRelay.value {
            return
        }
        triggerRelay.accept(())
    }

    /// Resets resource to the first page.
    public func reset() {
        currentPage = 0
        resultRelay.accept(nil)
    }

    /// Maps the underlying resource type lazily.
    /// - Parameters:
    ///   - transform: Method describing how the object should be transformed.
    public func map<TargetSuccess>(_ transform: @escaping (Success) -> TargetSuccess) -> PagedResource<TargetSuccess, Failure> {
        PagedResource<TargetSuccess, Failure>(
            pageProvider,
            transform: transform,
            errorTransform: { $0 }
        )
    }

    /// Maps the underlying resource error type lazily.
    /// - Parameters:
    ///   - transform: Method describing how the object should be transformed.
    public func mapError<TargetFailure: Error>(_ transform: @escaping (Failure) -> TargetFailure) -> PagedResource<Success, TargetFailure> {
        PagedResource<Success, TargetFailure>(
            pageProvider,
            transform: { $0 },
            errorTransform: transform
        )
    }

    // MARK: Private methods

    private func setupBindings() {
        disposeBag = DisposeBag()
        triggerRelay
            .do { [unowned self] _ in
                self.resultRelay.accept(self.currentPage == 0 ? .first(.loading) : .partial((self.resultRelay.value?.items ?? []), .loading))
            }
            .flatMapLatest { [unowned self] in
                self.pageProvider(self.currentPage)
            }
            .subscribe(onNext: { [unowned self] responseResult in
                let currentResult = self.resultRelay.value
                let currentItems = currentResult?.items ?? []
                switch responseResult {
                case let .success(response):
                    let items = response.items
                    let totalCount = response.totalCount
                    if currentItems.count + items.count == totalCount {
                        self.resultRelay.accept(.complete(currentItems + items))
                    } else {
                        self.currentPage += 1
                        self.resultRelay.accept(.partial(currentItems + items, nil))
                    }
                case let .failure(error):
                    if case .first = currentResult {
                        self.resultRelay.accept(.first(.failure(error)))
                    } else {
                        self.resultRelay.accept(.partial(currentItems, .failure(error)))
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
