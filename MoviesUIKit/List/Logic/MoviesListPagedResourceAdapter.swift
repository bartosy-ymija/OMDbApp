//
//  MoviesListPagedResourceAdapter.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import MoviesKit
import RxSwift
import ResourceKit

/// Describes an entity capable of converting movies kit model to a model which can be used in the paged resource.
protocol MoviesListPagedResourceAdapter {
    /// Converts data source to a representation which can be used in a paged resource.
    /// - Parameters:
    ///   - dataSource: Data source which should be converted.
    func convert(dataSource: Single<Result<MoviesSearchResponse, MoviesError>>) -> Single<Result<PagedResponse<MovieHeaderRepresentable>, MoviesListError>>
}
