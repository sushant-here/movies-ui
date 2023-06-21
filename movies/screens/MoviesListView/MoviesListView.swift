//
//  MoviesListView.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI

struct MoviesListView<Model>: View where Model: MoviesListViewModel {
    @ObservedObject var viewModel: Model

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(viewModel.loadingMessage)
                    .controlSize(.large)
                    .foregroundColor(.accentColor)
                    .tint(.accentColor)
            }

            List(viewModel.summaries, id: \.id) { movie in
                NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                    MovieSummaryListItem(summary: movie)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                .accessibilityLabel(movie.title)
                //.listRowSeparator(.hidden)
            }
            .listStyle(.inset)

        }
        .navigationTitle(viewModel.pageTitle)
        .onAppear(perform: viewModel.onAppear)
    }
}

#if DEBUG

class MoviesListViewModel_Preview: MoviesListViewModel {
    var pageTitle: String

    var isLoading: Bool
    var loadingMessage: String

    var summaries: [MovieSummary]

    func onAppear() {}

    init(pageTitle: String = "Swift UI Preview",
         isLoading: Bool,
         loadingMessage: String = "Loading message",
         summaries: [MovieSummary] = []) {
        self.pageTitle = pageTitle
        self.isLoading = isLoading
        self.loadingMessage = loadingMessage
        self.summaries = summaries
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviesListView(viewModel: MoviesListViewModel_Preview(isLoading: false, summaries: [MovieSummary.preview]))
                //.preferredColorScheme(.dark)
        }
        NavigationView {
            MoviesListView(viewModel: MoviesListViewModel_Preview(isLoading: true))
        }
    }
}
#endif
