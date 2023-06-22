//
//  moviesTests.swift
//  moviesTests
//
//  Created by Sushant Verma on 21/6/2023.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import movies

final class MoviesListViewModelTests: QuickSpec {
    override class func spec() {
        describe("MoviesListViewModelTests") {

            var moviesMock: MoviesServiceMock!
            var viewModel: (any MoviesListViewModel)!
            var viewModelInternal: MoviesListViewModelImpl!

            beforeEach {
                moviesMock = MoviesServiceMock()
                Resolver.shared.add(type: MoviesService.self) { moviesMock }
                viewModelInternal = MoviesListViewModelImpl()
                viewModel = viewModelInternal
            }

            context("before appear") {
                it("has correct page title") {
                    expect(viewModel.pageTitle).to(equal("Movies"))
                }

                it("has correct loading state") {
                    expect(viewModel.isLoading).to(beFalse())
                }

                it("has correct loading message") {
                    expect(viewModel.loadingMessage).to(equal("Loading movies"))
                }

                it("knows it hasnt appeared") {
                    expect(viewModelInternal.hasAppeared).to(beFalse())
                }

                it("contains no movies") {
                    expect(viewModelInternal.summaries).notTo(beNil())
                    expect(viewModelInternal.summaries).to(beEmpty())
                }
            }

            context("after appear") {
                beforeEach {
                    moviesMock.mockedPopularMovies = {
                        return CurrentValueSubject(TestData.moviesList)
                    }
                }

                it("knows it has appeared") {
                    expect(viewModelInternal.hasAppeared).to(beFalse())
                    viewModel.onAppear()
                    expect(viewModelInternal.hasAppeared).to(beTrue())
                }

                it("stops loading") {
                    expect(viewModel.isLoading).to(beFalse())
                    viewModel.onAppear()
                    expect(viewModel.isLoading).to(beTrue())
                }

                it("loads summaries") {
                    var moviesMockCount = 0
                    expect(viewModelInternal.summaries.count).to(equal(0))
                    moviesMock.mockedPopularMovies = {
                        //overrride
                        moviesMockCount+=1
                        return CurrentValueSubject(TestData.moviesList)
                    }
                    viewModel.onAppear()
                    expect(viewModelInternal.summaries.count).toEventually(equal(20))
                    expect(moviesMockCount).to(equal(1))
                }

            }

            context("movie summary details") {
                var movieSummary: MovieSummary!
                beforeEach {

                    moviesMock.mockedPopularMovies = {
                        return CurrentValueSubject(TestData.moviesList)
                    }
                    viewModel.onAppear()
                    waitUntil(timeout: .seconds(2)) { done in
                        DispatchQueue.main.async {
                            while viewModel.summaries.count == 0 {
                                Thread.sleep(forTimeInterval: 0.1)
                            }
                            if viewModel.summaries.count > 0 { done() }
                        }
                    }

                    movieSummary = viewModel.summaries.first
                }

                it("contains correct id") {
                    expect(movieSummary.id).toEventually(equal(385687))
                }

                it("contains correct backdrop") {
                    expect(movieSummary.backdropPath).toEventually(equal("/6l1SV3CWkbbe0DcAK1lyOG8aZ4K.jpg"))
                }

                it("contains correct poster") {
                    expect(movieSummary.posterPath).toEventually(equal("/fiVW06jE7z9YnO4trhaMEdclSiC.jpg"))
                }

                it("contains correct title") {
                    expect(movieSummary.title).toEventually(equal("Fast X"))
                }

                it("contains correct overview") {
                    expect(movieSummary.overview).toEventually(equal("Over many missions and against impossible odds, Dom Toretto and his family have outsmarted, out-nerved and outdriven every foe in their path. Now, they confront the most lethal opponent they've ever faced: A terrifying threat emerging from the shadows of the past who's fueled by blood revenge, and who is determined to shatter this family and destroy everything—and everyone—that Dom loves, forever."))
                }

                it("contains correct original language") {
                    expect(movieSummary.originalLanguage).toEventually(equal("en"))
                }

                it("contains correct voteCount") {
                    expect(movieSummary.voteCount).toEventually(equal(1813))
                }

                it("contains correct releaseDate") {
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    expect(dateFormat.string(from: movieSummary.releaseDate)).to(equal("2023-05-17"))
                    expect(dateFormat.date(from: "2023-05-17")).to(equal(movieSummary.releaseDate))
                }
            }
        }
    }
}
