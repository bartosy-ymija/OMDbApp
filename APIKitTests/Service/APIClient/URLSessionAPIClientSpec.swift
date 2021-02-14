//
//  URLSessionAPIClientSpec.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import APIKit

final class URLSessionAPIClientSpec: QuickSpec {

    private let fixtureStatus = "true"
    private lazy var jsonData = "{\"status\":\"\(fixtureStatus)\"}".data(using: .utf8)
    private let googleUrl = URL(string: "https://google.com")!

    override func spec() {
        describe("default api client with successful response containing json data") {
            let mockUrlSession = mockSession(data: jsonData)
            let apiClient = URLSessionAPIClient(
                urlSession: mockUrlSession,
                requestAuthorizer: MockRequestAuthorizer(url: googleUrl)
            )
            context("performing a valid request") {
                let disposeBag = DisposeBag()
                let request = MockRequest.default
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<MockResponse, RequestError>.self)
                apiClient.perform(request: request)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should parse json object") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .success(MockResponse(status: self.fixtureStatus))),
                                    .completed(0)
                                ]
                            )
                        )
                }
                it("should apply authorization") {
                    expect(mockUrlSession.urlRequest).to(equal(URLRequest(url: self.googleUrl)))
                }
            }
            context("performing an invalid request") {
                let disposeBag = DisposeBag()
                let request = InvalidRequest()
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<MockResponse, RequestError>.self)
                apiClient.perform(request: request)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return invalid request error") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .failure(.invalidRequest)),
                                    .completed(0)
                                ]
                            )
                        )
                }
            }
        }
        describe("default api client with successful response containing no data") {
            let mockUrlSession = mockSession(data: "".data(using: .utf8))
            let apiClient = URLSessionAPIClient(urlSession: mockUrlSession)
            context("performing a request") {
                let disposeBag = DisposeBag()
                let request = MockRequest.default
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<MockResponse, RequestError>.self)
                apiClient.perform(request: request)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return json parsing error") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .failure(.malformedResponse)),
                                    .completed(0)
                                ]
                            )
                        )
                }
            }
        }
        describe("default api client with unsuccessful response") {
            let mockUrlSession = mockSession(data: "".data(using: .utf8), statusCode: 404)
            let apiClient = URLSessionAPIClient(urlSession: mockUrlSession)
            context("performing a request") {
                let disposeBag = DisposeBag()
                let request = MockRequest.default
                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver(Result<MockResponse, RequestError>.self)
                apiClient.perform(request: request)
                    .asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
                it("should return api error") {
                    expect(observer.events)
                        .to(
                            equal(
                                [
                                    .next(0, .failure(.apiError)),
                                    .completed(0)
                                ]
                            )
                        )
                }
            }
        }
    }

    private func mockSession(data: Data?, statusCode: Int = 200) -> MockURLSession {
        MockURLSession(
            data: data,
            urlResponse: HTTPURLResponse(
                url: googleUrl,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )
    }
}
