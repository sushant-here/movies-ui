//
//  MovieDetailsResponse.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation

typealias MovieDetails = MovieDetailsResponse

struct MovieDetailsResponse: Decodable {
    let backdropPath: String
    let posterPath: String

    let id: Int?
    let title: String
    let tagline: String?
    let runtime: Int?
    let releaseDate: Date?

    let overview: String?

    let genres: [Genere]
    let homepage: URL?

    let budget: Int?
    let revenue: Int?

    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let imdbId: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id
        case title
        case tagline
        case runtime
        case releaseDate = "release_date"
        case overview
        case genres
        case homepage
        case budget
        case revenue
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case imdbId = "imdb_id"
    }

    init(backdropPath: String,
         posterPath: String,
         id: Int?,
         title: String,
         tagline: String?,
         runtime: Int?,
         releaseDate: Date?,
         overview: String?,
         genres: [Genere],
         homepage: URL?,
         budget: Int?,
         revenue: Int?,
         productionCompanies: [ProductionCompany],
         productionCountries: [ProductionCountry],
         imdbId: String?) {
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.id = id
        self.title = title
        self.tagline = tagline
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.overview = overview
        self.genres = genres
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.imdbId = imdbId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decode(String.self, forKey: .backdropPath)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)

        let jsonReleaseDate = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.releaseDate = dateFormatter.date(from: jsonReleaseDate)!

        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.genres = try container.decode([Genere].self, forKey: .genres)

        if let jsonHomepage = try container.decodeIfPresent(String.self, forKey: .homepage),
           !jsonHomepage.isEmpty {
            self.homepage = URL(string: jsonHomepage)
        } else {
            self.homepage = nil
        }
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.productionCompanies = try container.decode([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decode([ProductionCountry].self, forKey: .productionCountries)
        self.imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
    }
}

struct Genere: Decodable {
    let id: Int
    let name: String
}

struct ProductionCompany: Decodable {
    let id: Int
    let name: String
}


struct ProductionCountry: Decodable {
    let iso3166Code: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166Code = "iso_3166_1"
        case name
    }
}
