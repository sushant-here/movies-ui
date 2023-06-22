//
//  MoviesService.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Combine

protocol MoviesService {

    /// Loads a list of popular movies
    func loadPopularMovies() -> AnyPublisher<MovieListResponse, any Error>

    /// Gets details about a single movie
    func loadMovieDetails(id: Int) -> AnyPublisher<MovieDetailsResponse, any Error>
}
