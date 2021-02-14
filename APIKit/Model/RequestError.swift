//
//  RequestError.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Valid errors which can be reported while performing a request.
public enum RequestError: Error {
    /// Request couldn't be constructed.
    case invalidRequest
    /// API server reported an error.
    case apiError
    /// Response from the server couldn't be decoded.
    case malformedResponse
}
