//
//  MovieDetailsView.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView<Model>: View where Model: MovieDetailsViewModel {
    @ObservedObject
    var viewModel: Model

    @Environment(\.openURL)
    private var openURL

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView(viewModel.loadingMessage)
                    .controlSize(.large)
                    .foregroundColor(.accentColor)
                    .tint(.accentColor)
            } else if let movie = viewModel.movie {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        KFImage(URL(string: "\(TheMovieDB.image(width: 200).prefix)\(movie.posterPath)")!)
                            .resizable()
                            .cacheMemoryOnly()
                            .frame(width: 100, height: 150)
                            .border(.secondary)

                        VStack (alignment: .leading) {
                            Group {
                                Text(movie.title)
                                    .font(.title)

                                if let tagline = movie.tagline {
                                    Text(tagline)
                                        .font(.subheadline)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)

                    }

                    Spacer().frame(height: 10)
                    Grid() {
                        ForEach(viewModel.factoids) { fact in
                            GridRow (alignment: .top) {
                                Text("\(fact.label):")
                                    .gridColumnAlignment(.trailing)
                                Text(fact.value)
                                    .gridColumnAlignment(.leading)
                            }
                            .padding(1)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)

                    if let overview = movie.overview {
                        Spacer().frame(height: 10)
                        Text(overview)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer().frame(height: 10)
                    Button(action: openIMDB) {
                        Label(R.string.movieDetailsView.openInIMDB(), systemImage: "safari.fill")
                    }
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .frame(maxHeight: .infinity)
        .background(alignment: .center, content: {
            if viewModel.isLoading {
                EmptyView()
            } else if let movie = viewModel.movie {
                KFImage(URL(string: "\(TheMovieDB.image(width: 200).prefix)\(movie.backdropPath)")!)
                    .resizable()
                    .fade(duration: 1)
                    .cacheMemoryOnly() //makes dev abit easier
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.1)
            }
        })
        .navigationBarTitle(viewModel.pageTitle, displayMode: .inline)
        .onAppear(perform: viewModel.onAppear)
    }

    func openIMDB() {
        print("IMDB Action triggered")
        guard let url = viewModel.imdbUrl else {
            print("No IMDB URL available")
            return
        }
        openURL(url)
    }
}

#if DEBUG

class MovieDetailsViewModel_preview: MovieDetailsViewModel {
    var pageTitle: String

    var isLoading: Bool

    var loadingMessage: String

    var movie: MovieDetails? = MovieDetails(
        backdropPath: "/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg",
        posterPath: "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg",
        id: 603692,
        title: "Super awesome sample movie title",
        tagline: "In magical swift ui fashion",
        runtime: 321,
        releaseDate: Date.now,
        overview: "With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.",
        genres: [ Genere(id: 1, name: "Action"), Genere(id: 2, name: "Bromomance") ],
        homepage: URL(string: "https://tesla.com/")!,
        budget: 41239875,
        revenue: 9877654321,
        productionCompanies: [ ProductionCompany(id: 1, name: "Production A"), ProductionCompany(id: 2, name: "Production B") ],
        productionCountries: [ ProductionCountry(iso3166Code: "123", name: "Apples"), ProductionCountry(iso3166Code: "456", name: "Bananas") ],
        imdbId: "tt10366206")

    var factoids: [MovieFact] = [
        MovieFact(label: "A", value: "B\nasdf"),
        MovieFact(label: "C", value: "D"),
        MovieFact(label: "E", value: "F")
    ]

    var imdbUrl: URL? = nil

    func onAppear() {}

    init(pageTitle: String = "Preview",
         isLoading: Bool,
         loadingMessage: String = "Loading message") {
        self.pageTitle = pageTitle
        self.isLoading = isLoading
        self.loadingMessage = loadingMessage
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailsView(viewModel: MovieDetailsViewModel_preview(isLoading: false))
        }
        NavigationView {
            MovieDetailsView(viewModel: MovieDetailsViewModel_preview(isLoading: true))
        }
    }
}
#endif
