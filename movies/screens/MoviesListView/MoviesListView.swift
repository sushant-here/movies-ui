//
//  MoviesListView.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
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
                ZStack {
                    // Uggh i feel so dirty... We have to wrap in zstack and make nav link opaque so that we can hide the navigation chevron... https://stackoverflow.com/a/59832389
                    MovieSummaryListItem(summary: movie)
                    NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModelImpl(movieId: movie.id ))) {
                        EmptyView()
                    }
                    .opacity(0)
                    .buttonStyle(.plain)
                }
                .listRowInsets(EdgeInsets())
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
