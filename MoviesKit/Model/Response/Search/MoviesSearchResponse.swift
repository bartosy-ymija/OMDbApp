//
//  MoviesSearchResponse.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Response for the movies search request.
public struct MoviesSearchResponse: Decodable {
    public let totalCount: String?
    public let items: [MoviesSearchItemResponse]?
    public let error: String?

    public static let tooManyResultsErrorMessage = "Too many results."
    
    public static let invalidIdErrorMessage = "Incorrect IMDb ID."

    public init(totalCount: String?, items: [MoviesSearchItemResponse]?, error: String?) {
        self.totalCount = totalCount
        self.items = items
        self.error = error
    }

    enum CodingKeys: String, CodingKey {
        case totalCount = "totalResults"
        case items = "Search"
        case error = "Error"
    }
}
