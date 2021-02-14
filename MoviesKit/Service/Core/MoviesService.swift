//
//  MoviesService.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import RxSwift

/// Describes an entity capable of providing data about movies.
public protocol MoviesService {
    /// Performs search for movies including given query.
    /// - Parameters:
    ///   - query: Query to be searched for.
    ///   - page: Page of the requested results.
    func search(query: String, page: Int) -> Single<Result<MoviesSearchResponse, MoviesError>>
    /// Provides details for a movie with given details.
    /// - Parameters:
    ///   - id: Id of movie details to be provided.
    func movieDetails(id: String) -> Single<Result<MovieDetailsResponse, MoviesError>>
}
