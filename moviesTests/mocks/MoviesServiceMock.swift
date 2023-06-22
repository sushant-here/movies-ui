//
//  MoviesServiceMock.swift
//  moviesTests
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation
import Combine
@testable import movies

class MoviesServiceMock: MoviesService {
    var mockedPopularMovies: (() -> CurrentValueSubject<movies.MovieListResponse, Error>)!
    var mockedMovieDetails: (() -> CurrentValueSubject<movies.MovieDetailsResponse, Error>)!

    func loadPopularMovies() -> AnyPublisher<movies.MovieListResponse, Error> {
        return mockedPopularMovies().eraseToAnyPublisher()
    }

    func loadMovieDetails(id: Int) -> AnyPublisher<movies.MovieDetailsResponse, Error> {
        return mockedMovieDetails().eraseToAnyPublisher()
    }
}
