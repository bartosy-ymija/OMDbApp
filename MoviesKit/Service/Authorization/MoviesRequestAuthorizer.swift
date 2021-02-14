//
//  MoviesRequestAuthorizer.swift
//  MoviesKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import APIKit

/// Authorizer capable of authorizing movies request.
final class MoviesRequestAuthorizer: RequestAuthorizer {

    // MARK: Private properties

    private let apiKey: String

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - apiKey: Key used to authorize the API request.
    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func authorize(urlRequest: URLRequest) -> URLRequest? {
        guard let url = urlRequest.url else {
            return nil
        }
        let absoluteString = url.absoluteString
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let appendApiKey: ([String]) -> URLRequest? = { rawQueryItems in
            var queryItems = [String: String]()
            rawQueryItems.forEach { queryItem in
                let splitQueryItem = queryItem.split(separator: "=")
                guard splitQueryItem.count == 2 else {
                    return
                }
                let parameter = String(splitQueryItem[0])
                let value = String(splitQueryItem[1])
                queryItems[parameter] = value
            }
            queryItems["apikey"] = self.apiKey
            urlComponents?.queryItems = queryItems.map(URLQueryItem.init)
                .sorted { $0.name < $1.name }
            return urlComponents?.url.flatMap { URLRequest(url: $0) }
        }
        guard absoluteString.contains("?") else {
            return appendApiKey([])
        }
        guard let rawQueryItems = absoluteString.split(separator: "?").last?.split(separator: "&") else {
            return nil
        }
        return appendApiKey(rawQueryItems.map { String($0) })
    }
}
