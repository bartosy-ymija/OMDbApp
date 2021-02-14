//
//  MoviesSearchRequest.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import APIKit

struct MoviesSearchRequest: MoviesRequest {
    let method: HTTPMethod = .get

    var parameters: [String : String] {
        [
            "s": query,
            "type": "movie",
            "page": "\(page)"
        ]
    }

    let query: String

    let page: Int
}
