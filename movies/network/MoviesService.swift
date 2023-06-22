//
//  MoviesService.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Combine

protocol MoviesService {
    func loadPopularMovies() -> AnyPublisher<MovieListResponse, any Error>

    func loadMovieDetails(id: Int) -> AnyPublisher<MovieDetailsResponse, any Error>
}
