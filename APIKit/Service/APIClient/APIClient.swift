//
//  APIClient.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation
import RxSwift
import RxCocoa

/// Describes an entity capable of performing API requests.
public protocol APIClient {
    /// Performs an API request with the provided request data.
    /// - Parameters:
    ///   - request: Entity describing the request to the API.
    func perform<ResponseType: Decodable>(request: Request) -> Single<Result<ResponseType, RequestError>>
}
