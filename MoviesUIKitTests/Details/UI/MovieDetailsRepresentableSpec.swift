//
//  MovieDetailsRepresentableSpec.swift
//  MoviesUIKitTests
//
//  Created by Bartosz Żmija on 14/02/2021.
//

import Quick
import Nimble
@testable import MoviesKit
@testable import MoviesUIKit

final class MovieDetailsRepresentableSpec: QuickSpec {

    private let fixtureRuntime = "runtime"
    private let fixtureGenre = "genre"
    private let fixtureDirector = "director"
    private let fixtureWriter = "writer"
    private let fixtureActor = "actor"
    private let fixturePlot = "plot"
    private let fixtureRating = "rating"
    private let fixtureVotes = "votes"

    override func spec() {
        describe("movie details response with non-empty data") {
            let response = MovieDetailsResponse(
                title: "",
                year: "",
                runtime: fixtureRuntime,
                genre: "\(fixtureGenre)1, \(fixtureGenre)2",
                directors: "\(fixtureDirector)1, \(fixtureDirector)2",
                writers: "\(fixtureWriter)1, \(fixtureWriter)2",
                actors: "\(fixtureActor)1, \(fixtureActor)2",
                plot: fixturePlot,
                rating: fixtureRating,
                imageUrl: "",
                votes: fixtureVotes
            )
            context("when casting as movie details representable") {
                let detailsRepresentable: MovieDetailsRepresentable = response
                it("should propagate runtime") {
                    expect(detailsRepresentable.formattedRuntime).to(equal(self.fixtureRuntime))
                }
                it("should propagate split genre") {
                    expect(detailsRepresentable.splitGenre).to(equal(["\(self.fixtureGenre)1", "\(self.fixtureGenre)2"]))
                }
                it("should propagate split directors") {
                    expect(detailsRepresentable.splitDirectors).to(equal(["\(self.fixtureDirector)1", "\(self.fixtureDirector)2"]))
                }
                it("should propagate split writers") {
                    expect(detailsRepresentable.splitWriters).to(equal(["\(self.fixtureWriter)1", "\(self.fixtureWriter)2"]))
                }
                it("should propagate split actors") {
                    expect(detailsRepresentable.splitActors).to(equal(["\(self.fixtureActor)1", "\(self.fixtureActor)2"]))
                }
                it("should propagate plot") {
                    expect(detailsRepresentable.formattedPlot).to(equal(self.fixturePlot))
                }
                it("should propagate score") {
                    expect(detailsRepresentable.formattedScore).to(equal(self.fixtureRating))
                }
                it("should propagate votes") {
                    expect(detailsRepresentable.formattedReviews).to(equal(self.fixtureVotes))
                }
            }
        }
        describe("movie details response with empty data") {
            let response = MovieDetailsResponse(
                title: "",
                year: "",
                runtime: MovieDetailsResponse.emptyContent,
                genre: MovieDetailsResponse.emptyContent,
                directors: MovieDetailsResponse.emptyContent,
                writers: MovieDetailsResponse.emptyContent,
                actors: MovieDetailsResponse.emptyContent,
                plot: MovieDetailsResponse.emptyContent,
                rating: MovieDetailsResponse.emptyContent,
                imageUrl: "",
                votes: MovieDetailsResponse.emptyContent
            )
            context("when casting as movie details representable") {
                let detailsRepresentable: MovieDetailsRepresentable = response
                it("should propagate runtime") {
                    expect(detailsRepresentable.formattedRuntime).to(equal(""))
                }
                it("should propagate split genre") {
                    expect(detailsRepresentable.splitGenre).to(equal([]))
                }
                it("should propagate split directors") {
                    expect(detailsRepresentable.splitDirectors).to(equal([]))
                }
                it("should propagate split writers") {
                    expect(detailsRepresentable.splitWriters).to(equal([]))
                }
                it("should propagate split actors") {
                    expect(detailsRepresentable.splitActors).to(equal([]))
                }
                it("should propagate plot") {
                    expect(detailsRepresentable.formattedPlot).to(equal(MovieDetailsResponse.emptyPlotMessage))
                }
                it("should propagate score") {
                    expect(detailsRepresentable.formattedScore).to(equal(""))
                }
                it("should propagate votes") {
                    expect(detailsRepresentable.formattedReviews).to(equal(""))
                }
            }
        }
    }
}
