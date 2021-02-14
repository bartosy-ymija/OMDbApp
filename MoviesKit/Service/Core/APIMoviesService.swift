//
//  APIMoviesService.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import RxSwift
import APIKit

/// Movies service providing content using API client.
public final class APIMoviesService: MoviesService {

    // MARK: Private properties

    private let apiClient: APIClient

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - apiClient: Client performing the API calls.
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // MARK: Methods

    public func search(query: String, page: Int) -> Single<Result<MoviesSearchResponse, MoviesError>> {
        let request = MoviesSearchRequest(query: query, page: page)
        return apiClient.perform(request: request)
            .map { $0.mapError { _ in MoviesError.apiError } }
    }

    public func movieDetails(id: String) -> Single<Result<MovieDetailsResponse, MoviesError>> {
        let request = MovieDetailsRequest(id: id)
        return apiClient.perform(request: request)
            .map { $0.mapError { _ in MoviesError.apiError } }
    }
}
