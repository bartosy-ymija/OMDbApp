//
//  MovieDetailsRequest.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import APIKit

struct MovieDetailsRequest: MoviesRequest {
    let method: HTTPMethod = .get

    var parameters: [String : String] {
        [
            "i": id
        ]
    }

    let id: String
}
