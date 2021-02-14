//
//  MoviesAssembly.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import MoviesKit
import ResourceKit

final class MoviesAssembly {

    // MARK: Private properties

    private let module = MoviesKitModule()

    private let moviesListPagedResourceAdapter: MoviesListPagedResourceAdapter

    // MARK: Initializers

    init(moviesListPagedResourceAdapter: MoviesListPagedResourceAdapter = DefaultMoviesListPagedResourceAdapter()) {
        self.moviesListPagedResourceAdapter = moviesListPagedResourceAdapter
    }

    // MARK: Methods

    func moviesListViewController(showMovieDetails: @escaping (MovieHeaderRepresentable) -> Void) -> MoviesListViewController {
        let service = module.moviesService
        let viewModel = MoviesListViewModel(
            showMovieDetails: showMovieDetails,
            moviesResourceProvider: { [unowned self] query in
                PagedResource { [unowned self] page in
                    self.moviesListPagedResourceAdapter.convert(dataSource: service.search(query: query, page: page + 1))
                }
            }
        )
        return MoviesListViewController(viewModel: viewModel)
    }

    func movieDetailsViewController(movie: MovieHeaderRepresentable) -> MovieDetailsViewController {
        let service = module.moviesService
        let viewModel = MovieDetailsViewModel(
            movieHeader: movie,
            movieDetailsResource: Resource {
                service.movieDetails(id: movie.id)
                    .map { $0.mapError { _ in MovieDetailsError.detailsNotLoaded }
                        .map { $0 }
                    }
            }
        )
        return MovieDetailsViewController(viewModel: viewModel)
    }
}

extension MoviesSearchItemResponse: MovieHeaderRepresentable {}

extension MovieDetailsResponse: MovieDetailsRepresentable {
    var splitDirectors: [String] {
        directors == MovieDetailsResponse.emptyContent
            ? []
            : directors.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
    }

    var splitWriters: [String] {
        writers == MovieDetailsResponse.emptyContent
            ? []
            : writers.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
    }

    var splitActors: [String] {
        actors == MovieDetailsResponse.emptyContent
            ? []
            : actors.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
    }

    var formattedPlot: String {
        plot == MovieDetailsResponse.emptyContent ? MovieDetailsResponse.emptyPlotMessage : plot
    }

    var formattedScore: String {
        rating == MovieDetailsResponse.emptyContent ? "" : rating
    }

    var splitGenre: [String] {
        genre == MovieDetailsResponse.emptyContent
            ? []
            : genre.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    var formattedReviews: String {
        votes == MovieDetailsResponse.emptyContent ? "" : votes
    }

    var formattedRuntime: String {
        runtime == MovieDetailsResponse.emptyContent ? "" : runtime
    }

    static var emptyPlotMessage: String {
        "This movie doesn't have a plot summary yet."
    }
}
