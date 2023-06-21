//
//  MovieSummary.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

struct MovieSummary: Decodable {
    let backdropPath: String
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Decimal
    let posterPath: String
    let releaseDate: Date
    let title: String
    let voteAverage: Decimal
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(backdropPath: String,
         genreIDs: [Int],
         id: Int,
         originalLanguage: String,
         originalTitle: String,
         overview: String,
         popularity: Decimal,
         posterPath: String,
         releaseDate: Date,
         title: String,
         voteAverage: Decimal,
         voteCount: Int) {
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decode(String.self, forKey: .backdropPath)
        self.genreIDs = try container.decode([Int].self, forKey: .genreIDs)
        self.id = try container.decode(Int.self, forKey: .id)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Decimal.self, forKey: .popularity)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)

        let jsonReleaseDate = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.releaseDate = dateFormatter.date(from: jsonReleaseDate)!

        self.title = try container.decode(String.self, forKey: .title)
        self.voteAverage = try container.decode(Decimal.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}

#if DEBUG
extension MovieSummary {
    static var preview: MovieSummary {
        return MovieSummary(backdropPath: "/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg",
                            genreIDs: [28, 53, 80],
                            id: 603692,
                            originalLanguage: "en",
                            originalTitle: "John Wick: Chapter 4",
                            overview: "With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.",
                            popularity: Decimal(string: "2864.933")!,
                            posterPath: "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg",
                            releaseDate: Date(),
                            title: "John Wick: Chapter 4",
                            voteAverage: Decimal(string: "7.9")!,
                            voteCount: 3126)
    }
}
#endif
