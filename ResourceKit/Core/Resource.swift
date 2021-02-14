//
//  Resource.swift
//  ResourceKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import RxSwift

/// A wrapper on the method which returns a single upon calling.
public final class Resource<Success, Failure: Error> {

    // MARK: Private properties

    private let resolutionBlock: () -> Single<Result<Success, Failure>>

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - resolutionBlock: Block called on calling the `resolve` method.
    public init(_ resolutionBlock: @escaping () -> Single<Result<Success, Failure>>) {
        self.resolutionBlock = resolutionBlock
    }

    // MARK: Methods

    /// Resolves the resource.
    public func resolve() -> Single<Result<Success, Failure>> {
        resolutionBlock()
    }
}
