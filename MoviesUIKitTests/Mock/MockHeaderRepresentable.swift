//
//  MockHeaderRepresentable.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 10/02/2021.
//

@testable import MoviesUIKit

struct MockHeaderRepresentable: MovieHeaderRepresentable {
    let title: String
    let id: String = "id"
    let imagePath: String = "imagePath"
    let year: String = "year"
}
