//
//  MoviesRequest.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import APIKit

protocol MoviesRequest: Request {}

// MARK: Default values
extension MoviesRequest {
    var scheme: String {
        "https"
    }
    var basePath: String {
        "www.omdbapi.com"
    }
    var apiPath: String {
        ""
    }
    var resourcePath: String {
        "/"
    }
}
