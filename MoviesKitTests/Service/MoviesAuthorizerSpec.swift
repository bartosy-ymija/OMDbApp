//
//  MoviesAuthorizerSpec.swift
//  MoviesKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Quick
import Nimble
@testable import MoviesKit

final class MoviesAuthorizerSpec: QuickSpec {

    private let fixtureApiKey = "fixtureApiKey"
    private let fixtureParameter = "param"
    private let fixtureValue = "value"
    private let googlePath = "https://google.com/"

    override func spec() {
        describe("movie authorizer") {
            let authorizer = MoviesRequestAuthorizer(apiKey: fixtureApiKey)
            context("when authorizing url request without query parameters") {
                let urlRequest = URLRequest(url: URL(string: googlePath)!)
                it("should append api key as query parameter") {
                    expect(authorizer.authorize(urlRequest: urlRequest)?.url?.absoluteString).to(equal("\(self.googlePath)?apikey=\(self.fixtureApiKey)"))
                }
            }
            context("when authorizing url request with query parameters") {
                let urlRequest = URLRequest(url: URL(string: "\(googlePath)?\(fixtureParameter)=\(fixtureValue)")!)
                it("should append api key as query parameter") {
                    expect(authorizer.authorize(urlRequest: urlRequest)?.url?.absoluteString).to(equal("\(self.googlePath)?apikey=\(self.fixtureApiKey)&\(self.fixtureParameter)=\(self.fixtureValue)"))
                }
            }
        }
    }
}
