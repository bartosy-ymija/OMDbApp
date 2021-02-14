//
//  MovieDescriptionRepresentable.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import Foundation

protocol MovieDescriptionRepresentable {
    var splitGenre: [String] { get }
    var formattedPlot: String { get }
    var formattedScore: String { get }
    var formattedRuntime: String { get }
    var formattedReviews: String { get }
}
