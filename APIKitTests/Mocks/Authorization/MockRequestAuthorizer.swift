//
//  MockRequestAuthorizer.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

@testable import APIKit

final class MockRequestAuthorizer: RequestAuthorizer {

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func authorize(urlRequest: URLRequest) -> URLRequest? {
        URLRequest(url: url)
    }
}
