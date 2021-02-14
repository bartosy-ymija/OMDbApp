//
//  MockDetailsRepresentable.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 14/02/2021.
//

@testable import MoviesUIKit

struct MockDetailsRepresentable: MovieDetailsRepresentable {
    let splitGenre: [String] = []
    let formattedPlot: String = "plot"
    let formattedScore: String = "score"
    let formattedRuntime: String = "runtime"
    let formattedReviews: String = "reviews"
    let splitDirectors: [String] = []
    let splitWriters: [String] = []
    let splitActors: [String] = []
}
