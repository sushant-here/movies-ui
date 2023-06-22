//
//  MovieDetailsView.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI

struct MovieDetailsView<Model>: View where Model: MovieDetailsViewModel {
    @ObservedObject var viewModel: Model

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(viewModel.loadingMessage)
                    .controlSize(.large)
                    .foregroundColor(.accentColor)
                    .tint(.accentColor)
            }
        }
        .navigationTitle(viewModel.pageTitle)
        .onAppear(perform: viewModel.onAppear)
    }
}

#if DEBUG

class MovieDetailsViewModel_preview: MovieDetailsViewModel {
    var pageTitle: String

    var isLoading: Bool

    var loadingMessage: String

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
