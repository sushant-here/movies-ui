//
//  MovieSummary.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

struct MovieSummary: Decodable {
    let id: Int

    let backdropPath: String?
    let posterPath: String?

    let title: String?
    let overview: String?

    let originalLanguage: String?
    let voteCount: Int?
    let releaseDate: Date?

    enum CodingKeys: String, CodingKey {
        case id

        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"

        case title
        case overview

        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }

    init(id: Int,
         backdropPath: String?,
         posterPath: String?,
         title: String?,
         overview: String?,
         originalLanguage: String?,
         voteCount: Int?,
         releaseDate: Date?) {
        self.id = id
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
        self.originalLanguage = originalLanguage
        self.voteCount = voteCount
        self.releaseDate = releaseDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)

        if let jsonReleaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: jsonReleaseDate)!
        } else {
            self.releaseDate = nil
        }
    }
}

extension MovieSummary {
    var backdropUrl: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(TheMovieDB.image(width: 200).prefix)\(backdropPath)")
    }
    var posterUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(TheMovieDB.image(width: 200).prefix)\(posterPath)")
    }
}

#if DEBUG
extension MovieSummary {
    static var preview: MovieSummary {
        return MovieSummary(id: 603692,
                            backdropPath: "/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg",
                            posterPath: "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg",
                            title: "The solution 42",
                            overview: "With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.",
                            originalLanguage: "en",
                            voteCount: 1234,
                            releaseDate: .now)
    }
}
#endif
