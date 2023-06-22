//
//  MoviesViewModel.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation
import Combine

protocol MoviesListViewModel: ObservableObject {
    //MARK: Display fields
    var pageTitle: String { get }

    var isLoading: Bool { get }
    var loadingMessage: String { get }

    var summaries: [MovieSummary] { get }

    //MARK: Lifecycle
    func onAppear()
}

class MoviesListViewModelImpl: MoviesListViewModel {

    //MARK: Local stuff
    @Inject
    private var movieService: MoviesService

    private var cancellable = Set<AnyCancellable> ()

    //MARK: Display fields

    @Published
    var pageTitle: String = R.string.moviesListView.pageTitle()

    @Published
    var isLoading: Bool = false

    @Published
    var loadingMessage: String = R.string.moviesListView.loadingMessage()

    @Published
    var summaries: [MovieSummary] = []

    var hasAppeared = false

    //MARK: Lifecycle
    func onAppear() {
        guard !hasAppeared else { return }
        hasAppeared = true

        print("preparing ui")

        loadMovies()
    }

    private func loadMovies() {
        isLoading = true

        URLCache.shared.removeAllCachedResponses()
        
        summaries = []
        movieService.loadPopularMovies()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    //FIXME: properly should do more informative error handling.
                    print("Unable to load movies. Error: \(error)")
                case .finished:
                    print("Done loading movies successfully")
                }
                self.isLoading = false
            } receiveValue: { [weak self] movies in
                guard let self = self else { return }
                self.summaries = movies.results
            }
            .store(in: &cancellable)
    }
}
