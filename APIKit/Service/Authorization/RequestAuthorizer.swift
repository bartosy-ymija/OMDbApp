//
//  RequestAuthorizer.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Describes an entity capable of authorizing the url request.
public protocol RequestAuthorizer {
    /// Returns authorized url request.
    /// - Parameters:
    ///   - urlRequest: url request to be authorized.
    func authorize(urlRequest: URLRequest) -> URLRequest?
}
