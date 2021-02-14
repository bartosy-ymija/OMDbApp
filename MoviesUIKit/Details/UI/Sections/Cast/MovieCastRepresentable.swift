//
//  MovieCastRepresentable.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 13/02/2021.
//

/// Describes an entity which can be rendered in the movie cast view.
protocol MovieCastRepresentable {
    var splitDirectors: [String] { get }
    var splitWriters: [String] { get }
    var splitActors: [String] { get }
}
