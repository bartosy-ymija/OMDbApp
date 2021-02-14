//
//  RequestSpec.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Quick
import Nimble

final class RequestSpec: QuickSpec {

    override func spec() {
        describe("request") {
            let request = MockRequest.default
            context("when converting to URLRequest") {
                let urlRequest = request.asUrlRequest()
                it("should have valid url") {
                    expect(urlRequest?.url).to(equal(URL(string: "\(request.scheme)://\(request.basePath)/\(request.apiPath)/\(request.resourcePath)?\(MockRequest.fixtureParamKey)=\(MockRequest.fixtureParamValue)")))
                }
            }
        }
    }
}
