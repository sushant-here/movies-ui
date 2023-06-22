//
//  MovieDetailsViewModel.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation
import Combine

protocol MovieDetailsViewModel: ObservableObject {
    //MARK: Display fields
    var pageTitle: String { get }

    var isLoading: Bool { get }
    var loadingMessage: String { get }

    // var movie: MovieDetails { get }

    //MARK: Lifecycle
    func onAppear()
}

class MovieDetailsViewModelImpl: MovieDetailsViewModel {
    
    //MARK: Display fields
    var movieId: Int

    var pageTitle: String = R.string.movieDetailsView.pageTitle()

    @Published
    var isLoading: Bool = false

    @Published
    var loadingMessage: String = R.string.movieDetailsView.loadingMessage()

    var hasAppeared = false

    //MARK: Lifecycle
    init(movieId: Int) {
        self.movieId = movieId
    }

    func onAppear() {
        guard !hasAppeared else { return }
        hasAppeared = true

        loadMovie()
    }

    func loadMovie() {
        isLoading = true
    }
}
