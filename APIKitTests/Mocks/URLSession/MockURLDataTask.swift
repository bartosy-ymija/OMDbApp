//
//  MockURLSessionDataTask.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }

    override func cancel() {}
}
