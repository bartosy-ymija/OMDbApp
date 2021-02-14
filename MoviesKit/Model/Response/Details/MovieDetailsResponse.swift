//
//  MovieDetailsResponse.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//


public struct MovieDetailsResponse: Decodable {
    public let title: String
    public let year: String
    public let runtime: String
    public let genre: String
    public let directors: String
    public let writers: String
    public let actors: String
    public let plot: String
    public let rating: String
    public let imageUrl: String
    public let votes: String

    public static let emptyContent = "N/A"

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case runtime = "Runtime"
        case genre = "Genre"
        case directors = "Director"
        case writers = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case rating = "imdbRating"
        case imageUrl = "Poster"
        case votes = "imdbVotes"
    }
}
