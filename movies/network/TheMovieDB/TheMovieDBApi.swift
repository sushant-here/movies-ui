//
//  TheMovieDBApi.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

enum TheMovieDB {
    case api
    case image(width: Int)

    var prefix: String {
        switch self {
        case .api:
            return "https://api.themoviedb.org/"
        case .image(let width):
            return "https://image.tmdb.org/t/p/w\(width)/"
        }
    }
}
enum TheMovieDBEndpoint: String {
    case movieList = "3/discover/movie"

    var url: URL {
        let base = TheMovieDB.api.prefix
        let path: String

        switch self {
        case .movieList:
            path = self.rawValue
        }

        return URL(string: "\(base)\(path)")!
    }

    var httpMethod: String {
        switch self {
        case .movieList:
            return "GET"
        }
    }

    func urlRequest(withBearer bearer: String) -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = self.httpMethod

        request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")

        return request
    }
}
