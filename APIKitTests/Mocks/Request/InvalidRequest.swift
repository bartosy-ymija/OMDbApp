//
//  InvalidRequest.swift
//  APIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

@testable import APIKit
import Foundation

struct InvalidRequest: Request {

    let method: HTTPMethod = .get
    let basePath: String = ""
    let apiPath: String = ""
    let resourcePath: String = ""
    let parameters: [String : String] = [:]

    func asUrlRequest() -> URLRequest? {
        nil
    }
}
