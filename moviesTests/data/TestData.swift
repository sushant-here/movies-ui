//
//  TestData.swift
//  moviesTests
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation

@testable import movies

class TestData {

    static var moviesList: MovieListResponse {
        let url = R.file.moviesJson.url()!
        let data = try! Data(contentsOf: url)

        return try! JSONDecoder().decode(MovieListResponse.self,
                                         from: data)
    }

    static var movieDetails: MovieDetailsResponse {
        let url = R.file.movie_603692Json.url()!
        let data = try! Data(contentsOf: url)

        return try! JSONDecoder().decode(MovieDetailsResponse.self,
                                         from: data)
    }
}
