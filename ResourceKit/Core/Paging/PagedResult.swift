//
//  PagedResult.swift
//  ResourceKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Valid paged results.
public enum PagedResult<Success, Failure: Error>: Equatable {
    /// First page status is available.
    case first(PartialStatus<Failure>)
    /// Partial results are available along with an optional status.
    case partial([Success], PartialStatus<Failure>?)
    /// All results are available.
    case complete([Success])

    /// Returns contained items.
    public var items: [Success] {
        switch self {
        case .first:
            return []
        case let .partial(items, _):
            return items
        case let .complete(items):
            return items
        }
    }

    public static func ==(lhs: PagedResult<Success, Failure>, rhs: PagedResult<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case let (.first(lStatus), .first(rStatus)):
            return lStatus == rStatus
        case let (.partial(lItems, lStatus), .partial(rItems, rStatus)):
            return lItems.count == rItems.count && lStatus == rStatus
        case (.complete, .complete):
            return true
        default:
            return false
        }
    }
}
