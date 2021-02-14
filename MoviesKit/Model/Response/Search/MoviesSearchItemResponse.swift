//
//  MoviesSearchItemResponse.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Entity inside of the movies search result list.
public struct MoviesSearchItemResponse: Decodable {
    public let title: String
    public let id: String
    public let imagePath: String
    public let year: String

    init(
        title: String,
        id: String,
        imagePath: String,
        year: String
    ) {
        self.title = title
        self.id = id
        self.imagePath = imagePath
        self.year = year
    }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case id = "imdbID"
        case imagePath = "Poster"
        case year = "Year"
    }
}
