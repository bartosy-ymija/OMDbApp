//
//  DefaultMoviesListPagedResourceAdapter.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import MoviesKit
import RxSwift
import ResourceKit

final class DefaultMoviesListPagedResourceAdapter: MoviesListPagedResourceAdapter {
    func convert(dataSource: Single<Result<MoviesSearchResponse, MoviesError>>) -> Single<Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>> {
        dataSource.map {
            $0.mapError { _ in MoviesListError.listNotLoaded }
                .flatMap { response in
                if let items = response.items,
                   let totalCountString = response.totalCount,
                   let totalCount = Int(totalCountString) {
                    return .success(PagedResponse(items: items, totalCount: totalCount))
                }
                if let error = response.error,
                   error == MoviesSearchResponse.tooManyResultsErrorMessage ||
                    error == MoviesSearchResponse.invalidIdErrorMessage {
                    return .failure(MoviesListError.tooManyResults)
                }
                return .success(PagedResponse(items: [], totalCount: 0))
            }
        }
    }
}
