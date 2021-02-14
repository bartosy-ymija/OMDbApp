//
//  Request.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Describes an entity containing information needed to perform an API request.
public protocol Request {
    /// Scheme used by this request.
    var scheme: String { get }
    /// HTTP method used to perform the request.
    var method: HTTPMethod { get }
    /// Base path of the requested service.
    var basePath: String { get }
    /// API version path of the requested service.
    var apiPath: String { get }
    /// Path to the resource in the requested service.
    var resourcePath: String { get }
    /// Contains query parameters of the request.
    var parameters: [String: String] { get }
    /// Converts request to the URL Request.
    func asUrlRequest() -> URLRequest?
}

// MARK: Default parameters
extension Request {
    var scheme: String {
        "https"
    }
}

// MARK: URLRequest conversion
extension Request {
    public func asUrlRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = "\(basePath)"
        urlComponents.path = "/\(apiPath)/\(resourcePath)"
        urlComponents.queryItems = parameters.map(URLQueryItem.init)
        return urlComponents.url.flatMap { URLRequest(url: $0) }
    }
}
