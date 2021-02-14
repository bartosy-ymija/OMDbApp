//
//  MoviesListError.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Possible error which can be encountered on the movies list screen.
public enum MoviesListError: Error {
    /// Indicates that the list couldn't be loaded.
    case listNotLoaded
    /// Indicates that there has been too many results for a given query.
    case tooManyResults
    /// Indicates that the query is empty.
    case emptyQuery
}
