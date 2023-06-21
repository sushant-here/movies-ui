//
//  MoviesResponse.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let results: [MovieSummary]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
