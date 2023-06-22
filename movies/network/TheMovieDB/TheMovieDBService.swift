//
//  TheMovieDBService.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation
import Combine

class TheMovieDBService: MoviesService {
    struct Config: Decodable {
        let accessToken: String
    }

    private static let config: Config = {
        let url = R.file.theMovieDBPlist.url()!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Config.self, from: data)
    }()

    private let accessToken = TheMovieDBService.config.accessToken

    func loadPopularMovies() -> AnyPublisher<MovieListResponse, any Error> {
        return URLSession.shared.dataTaskPublisher(for: TheMovieDBEndpoint.movieList.urlRequest(withBearer: accessToken))
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: MovieListResponse.self, decoder: JSONDecoder())
//        #if targetEnvironment(simulator)
//            .delay(for: 2, scheduler: RunLoop.main)
//        #endif
            .eraseToAnyPublisher()
    }

    func loadMovieDetails(id: Int) -> AnyPublisher<MovieDetailsResponse, any Error> {
        return URLSession.shared.dataTaskPublisher(for: TheMovieDBEndpoint.movieDetails(id).urlRequest(withBearer: accessToken))
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: MovieDetailsResponse.self, decoder: JSONDecoder())
//        #if targetEnvironment(simulator)
//            .delay(for: 2, scheduler: RunLoop.main)
//        #endif
            .eraseToAnyPublisher()
    }
}
