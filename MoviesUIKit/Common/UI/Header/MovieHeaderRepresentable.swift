//
//  MovieHeaderRepresentable.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Describes an entity which can be displayed in the movie header view.
public protocol MovieHeaderRepresentable {
    var title: String { get }
    var id: String { get }
    var imagePath: String { get }
    var year: String { get }
}
