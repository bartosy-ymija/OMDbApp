//
//  MoviesKitModule.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import APIKit

public final class MoviesKitModule {

    private lazy var requestAuthorizer = MoviesRequestAuthorizer(apiKey: "b9bd48a6")

    private lazy var apiClient = URLSessionAPIClient(requestAuthorizer: requestAuthorizer)

    public lazy var moviesService = APIMoviesService(
        apiClient: apiClient
    )

    public init() {}
}
