//
//  MovieDetailsView.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
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
            } else {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if let posterUrl = viewModel.posterUrl {
                            KFImage(posterUrl)
                                .resizable()
                                .cacheMemoryOnly()
                                .frame(width: 100, height: 150)
                                .border(.secondary)
                        }

                        VStack (alignment: .leading) {
                            Group {
                                if let title = viewModel.movieTitle {
                                    Text(title)
                                        .font(.title)
                                }

                                if let tagline = viewModel.movieTagline {
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

                    if let overview = viewModel.movieOverview {
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
            } else if let backdropUrl = viewModel.backdropUrl {
                KFImage(backdropUrl)
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
    var posterUrl: URL?

    var backdropUrl: URL?

    var movieTitle: String?

    var movieTagline: String?

    var movieOverview: String?

    var pageTitle: String

    var isLoading: Bool

    var loadingMessage: String

    var factoids: [MovieFact] = [
        MovieFact(label: "Some Field", value: "this one has\ntwo lines"),
        MovieFact(label: "Another Field", value: "Only one here"),
        MovieFact(label: "Field", value: "And this is very very long as you can see so that its possible to see the text wrap to another line")
    ]

    var imdbUrl: URL? = nil

    func onAppear() {}

    init(pageTitle: String = "Preview",
         posterUrl: URL? = URL(string: "https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg"),
         backdropUrl: URL? = URL(string: "https://image.tmdb.org/t/p/w500/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg"),
         movieTitle: String? = "Super awesome sample movie title",
         movieTagline: String? = "In magical swift ui fashion",
         movieOverview: String? = "With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.",
         isLoading: Bool,
         loadingMessage: String = "Loading message") {
        self.pageTitle = pageTitle
        self.posterUrl = posterUrl
        self.backdropUrl = backdropUrl
        self.movieTitle = movieTitle
        self.movieTagline = movieTagline
        self.movieOverview = movieOverview
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
