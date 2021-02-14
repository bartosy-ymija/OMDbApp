//
//  MoviesListState.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Possible state on the movies list screen.
public enum MoviesListState {
    /// List is loaded.
    case loading
    /// There's been an error while loading the list.
    case failure(MoviesListError)
    /// Some itmes are ready.
    case partial([MovieHeaderRepresentable])
    /// Some items are ready and next page is loading.
    case partialLoading([MovieHeaderRepresentable])
    /// Some items are ready and there's been an error while loading next page.
    case partialFailure([MovieHeaderRepresentable], MoviesListError)
    /// All items has been loaded.
    case complete([MovieHeaderRepresentable])

    /// Items contained in the state.
    var items: [MovieHeaderRepresentable] {
        switch self {
        case let .complete(items):
            return items
        case let .partial(items):
            return items
        case let .partialFailure(items, _):
            return items
        case let .partialLoading(items):
            return items
        default:
            return []
        }
    }
}

extension MoviesListState: Equatable {

    public static func ==(lhs: MoviesListState, rhs: MoviesListState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failure, .failure):
            return true
        case let (.partial(lItems), .partial(rItems)):
            return lItems.count == rItems.count
        case let (.partialLoading(lItems), .partialLoading(rItems)):
            return lItems.count == rItems.count
        case let (.partialFailure(lItems, _), .partialFailure(rItems, _)):
            return lItems.count == rItems.count
        case let (.complete(lItems), .complete(rItems)):
            return lItems.count == rItems.count
        default:
            return false
        }
    }
}
