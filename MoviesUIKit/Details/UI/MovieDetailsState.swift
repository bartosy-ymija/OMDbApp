//
//  MovieDetailsState.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import Foundation

/// Valid state of the movie details screen.
enum MovieDetailsState {
    /// Header information is available.
    case header(MovieHeaderRepresentable)
    /// Header information is available, but details fetch failed.
    case failure(MovieHeaderRepresentable)
    /// Header and details information are available.
    case complete(MovieHeaderRepresentable, MovieDetailsRepresentable)

    /// Returns associated information.
    var header: MovieHeaderRepresentable {
        switch self {
        case let .header(header):
            return header
        case let .failure(header):
            return header
        case let .complete(header, _):
            return header
        }
    }
}
