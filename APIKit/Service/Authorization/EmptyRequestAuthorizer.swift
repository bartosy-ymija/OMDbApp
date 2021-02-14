//
//  EmptyRequestAuthorizer.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Request authorizer which returns an identity.
public final class EmptyRequestAuthorizer: RequestAuthorizer {

    // MARK: Initializers

    public init() {}

    // MARK: Methods

    public func authorize(urlRequest: URLRequest) -> URLRequest? {
        urlRequest
    }
}
