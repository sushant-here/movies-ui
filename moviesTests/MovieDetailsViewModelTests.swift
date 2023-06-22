//
//  MovieDetailsViewModelTests.swift
//  moviesTests
//
//  Created by Sushant Verma on 22/6/2023.
//

import Quick
import Nimble
import Combine
import Foundation
@testable import movies

final class MovieDetailsViewModelTests: QuickSpec {
    override class func spec() {
        describe("MovieDetailsViewModel") {

            var moviesMock: MoviesServiceMock!
            var viewModel: (any MovieDetailsViewModel)!
            var viewModelInternal: MovieDetailsViewModelImpl!
            var cancellable = Set<AnyCancellable> ()

            beforeEach {
                moviesMock = MoviesServiceMock()
                Resolver.shared.add(type: MoviesService.self) { moviesMock }
                viewModelInternal = MovieDetailsViewModelImpl(movieId: 0)//this id shouldnt matter
                viewModel = viewModelInternal
            }

            context("before appear") {
                it("has correct page title") {
                    expect(viewModel.pageTitle).to(equal("Details"))
                }

                it("has correct loading state") {
                    expect(viewModel.isLoading).to(beFalse())
                }

                it("has correct loading message") {
                    expect(viewModel.loadingMessage).to(equal("Loading movie"))
                }

                it("knows it hasnt appeared") {
                    expect(viewModelInternal.hasAppeared).to(beFalse())
                }

                it("has no posterUrl") {
                    expect(viewModel.posterUrl).to(beNil())
                }

                it("has no backdropUrl") {
                    expect(viewModel.backdropUrl).to(beNil())
                }

                it("has no movieTitle") {
                    expect(viewModel.movieTitle).to(beNil())
                }

                it("has no movieTagline") {
                    expect(viewModel.movieTagline).to(beNil())
                }

                it("has no movieOverview") {
                    expect(viewModel.movieOverview).to(beNil())
                }

                it("has no factoids") {
                    expect(viewModel.factoids).to(beEmpty())
                }

                it("has no imdbUrl") {
                    expect(viewModel.imdbUrl).to(beNil())
                }
            }

            context("after appear") {
                beforeEach {
                    moviesMock.mockedMovieDetails = {
                        return CurrentValueSubject(TestData.movieDetails)
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

                it("loads correct number of times") {
                    var moviesMockCount = 0
                    expect(viewModel.movieTitle).to(beNil())
                    moviesMock.mockedMovieDetails = {
                        //overrride
                        moviesMockCount+=1
                        return CurrentValueSubject(TestData.movieDetails)
                    }
                    viewModel.onAppear()
                    expect(viewModel.movieTitle).toEventually(equal("John Wick: Chapter 4"))
                    expect(moviesMockCount).to(equal(1))
                }

            }

            context("movie details") {
                beforeEach {

                    moviesMock.mockedMovieDetails = {
                        return CurrentValueSubject(TestData.movieDetails)
                    }
                    viewModel.onAppear()
                    waitUntil(timeout: .seconds(2)) { done in
                        viewModel.movieTitle.publisher.sink { _ in
                            done()
                        }.store(in: &cancellable)
                    }
                }

                it("has posterUrl") {
                    expect(viewModel.posterUrl).toEventually(equal(URL(string: "https://image.tmdb.org/t/p/w200/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg")))
                }

                it("has backdropUrl") {
                    expect(viewModel.backdropUrl).toEventually(equal(URL(string: "https://image.tmdb.org/t/p/w200/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg")))
                }

                it("has movieTitle") {
                    expect(viewModel.movieTitle).toEventually(equal("John Wick: Chapter 4"))
                }

                it("has movieTagline") {
                    expect(viewModel.movieTagline).toEventually(equal("No way back, one way out."))
                }

                it("has movieOverview") {
                    expect(viewModel.movieOverview).toEventually(equal("With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes."))
                }

                context("factoids") {
                    it("has factoids") {
                        expect(viewModel.factoids.count)
                            .toEventually(equal(7))
                    }

                    it("has formatted release date") {
                        expect(viewModel.factoids.filter({ $0.label == "Release date" && $0.value == "Mar 22, 2023" }).count)
                            .toEventually(equal(1))
                    }

                    it("has formatted revenue") {
                        expect(viewModel.factoids.filter({ $0.label == "Revenue" && $0.value == "$431,769,198" }).count)
                            .toEventually(equal(1))
                    }

                    it("has formatted budget") {
                        expect(viewModel.factoids.filter({ $0.label == "Budget" && $0.value == "$90,000,000" }).count)
                            .toEventually(equal(1))
                    }

                    it("has formatted runtime") {
                        expect(viewModel.factoids.filter({ $0.label == "Runtime" && $0.value == "170 min" }).count)
                            .toEventually(equal(1))
                    }

                    it("has generes") {
                        expect(viewModel.factoids.filter({ $0.label == "Generes" && $0.value == "Action, Thriller, Crime" }).count)
                            .toEventually(equal(1))
                    }

                    it("has production companies") {
                        expect(viewModel.factoids.filter({ $0.label == "Production companies" && $0.value == "Thunder Road, 87Eleven, Summit Entertainment, Studio Babelsberg" }).count)
                            .toEventually(equal(1))
                    }

                    it("has production countries") {
                        expect(viewModel.factoids.filter({ $0.label == "Production countries" && $0.value == "Germany, United States of America" }).count)
                            .toEventually(equal(1))
                    }
                }

                it("has imdbUrl") {
                    expect(viewModel.imdbUrl).toEventually(equal(URL(string: "https://www.imdb.com/title/tt10366206/")))
                }
            }
        }
    }
}
