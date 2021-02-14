//
//  URLSessionAPIClient.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation
import RxSwift

/// URLSession-based implementation of the API client.
public final class URLSessionAPIClient: APIClient {

    // MARK: Private properties

    private let urlSession: URLSession

    private let decoder: Decoder

    private let requestAuthorizer: RequestAuthorizer

    // MARK: Initializers

    /// Initializes the receiver.
    /// - Parameters:
    ///   - urlSession: Instance of urlSession used to perform requests. Defaults to shared.
    ///   - decoder: Entity capable  of decoding data. Defaults to JSONDecoder
    ///   - requestAuthorizer: Entity which authorizes the request.
    public init(
        urlSession: URLSession = .shared,
        decoder: Decoder = JSONDecoder(),
        requestAuthorizer: RequestAuthorizer = EmptyRequestAuthorizer()
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.requestAuthorizer = requestAuthorizer
    }

    // MARK: Methods

    public func perform<ResponseType>(request: Request) -> Single<Result<ResponseType, RequestError>> where ResponseType : Decodable {
        guard let urlRequest = request.asUrlRequest(),
              let authorizedRequest = requestAuthorizer.authorize(urlRequest: urlRequest) else {
            return Single.just(.failure(.invalidRequest))
        }
        return urlSession.rx.response(request: authorizedRequest).map { [unowned self] response, data in
            switch response.statusCode {
            case (200..<300):
                guard let decodedResponse: ResponseType = self.decoder.decode(data: data) else {
                    return .failure(.malformedResponse)
                }
                return .success(decodedResponse)
            default:
                return .failure(.apiError)
            }
        }
        .catchError { error in
            return Observable.just(.failure(.apiError))
        }
        .observeOn(MainScheduler.instance)
        .asSingle()
    }
}
