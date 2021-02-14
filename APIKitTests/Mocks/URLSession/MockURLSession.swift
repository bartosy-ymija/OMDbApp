//
//  MockURLSession.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

final class MockURLSession: URLSession {

    private let data: Data?
    private let urlResponse: URLResponse?
    private let error: Error?

    private(set) var urlRequest: URLRequest?

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        urlRequest = request
        return MockURLSessionDataTask {
            completionHandler(self.data, self.urlResponse, self.error)
        }
    }
}
