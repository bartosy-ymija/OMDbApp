//
//  MockRequest.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

@testable import APIKit

struct MockRequest: Request {
    static let fixtureBasePath = "base.path"
    static let fixtureApiPath = "v2"
    static let fixtureResourcePath = "resource"
    static let fixtureParamKey = "param"
    static let fixtureParamValue = "value"
    static let fixtureParameters = [MockRequest.fixtureParamKey: MockRequest.fixtureParamValue]

    let method: HTTPMethod
    let basePath: String
    let apiPath: String
    let resourcePath: String
    let parameters: [String : String]

    static let `default` = MockRequest(
        method: .get,
        basePath: MockRequest.fixtureBasePath,
        apiPath: MockRequest.fixtureApiPath,
        resourcePath: MockRequest.fixtureResourcePath,
        parameters: MockRequest.fixtureParameters
    )
}
