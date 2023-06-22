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

    var movie: MovieDetails? { get }

    //MARK: Lifecycle
    func onAppear()
}

class MovieDetailsViewModelImpl: MovieDetailsViewModel {

    //MARK: Local stuff
    @Inject
    private var movieService: MoviesService

    private var cancellable = Set<AnyCancellable> ()

    //MARK: Display fields
    var movieId: Int

    var pageTitle: String = R.string.movieDetailsView.pageTitle()

    @Published
    var isLoading: Bool = false

    @Published
    var loadingMessage: String = R.string.movieDetailsView.loadingMessage()

    @Published
    var movie: MovieDetails?

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

        movieService.loadMovieDetails(id: movieId)
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
            } receiveValue: { [weak self] movie in
                guard let self = self else { return }
                self.movie = movie
            }
            .store(in: &cancellable)
    }
}
