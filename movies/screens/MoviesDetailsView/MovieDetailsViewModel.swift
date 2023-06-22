//
//  MovieDetailsViewModel.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import Foundation
import Combine

struct MovieFact: Identifiable {
    var id: String { "\(label):\(value)" }

    let label: String
    let value: String
}

protocol MovieDetailsViewModel: ObservableObject {
    //MARK: Display fields
    var pageTitle: String { get }

    var isLoading: Bool { get }
    var loadingMessage: String { get }

    var movie: MovieDetails? { get }

    var factoids: [MovieFact] { get }

    var imdbUrl: URL? { get }

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
    var movie: MovieDetails? {
        didSet {
            updateFactoids()
        }
    }

    @Published
    var factoids: [MovieFact] = []

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

    private func updateFactoids() {
        factoids.removeAll()

        if let releaseDate = movie?.releaseDate {
            let formatted = Date.FormatStyle().year().month().day().format(releaseDate)
            factoids.append(MovieFact(label: R.string.movieDetailsView.releaseDate(),
                                      value: formatted))
        }

        let moneyFormatter = NumberFormatter()
        moneyFormatter.locale = Locale(identifier: "EN-US")
        moneyFormatter.numberStyle = .currency
        moneyFormatter.maximumFractionDigits = 0

        if let primativeRevenue = movie?.revenue,
           primativeRevenue > 0 {
            let revenue = NSNumber(value: primativeRevenue)

            if let formatted = moneyFormatter.string(from: revenue) {
                factoids.append(MovieFact(label: R.string.movieDetailsView.revenue(),
                                          value: formatted))
            }
        }

        if let primitiveBudget = movie?.budget,
           primitiveBudget > 0  {
            let budget = NSNumber(value: primitiveBudget)

            if let formatted = moneyFormatter.string(from: budget) {
                factoids.append(MovieFact(label: R.string.movieDetailsView.budget(),
                                          value: formatted))
            }
        }

        if let runtime = movie?.runtime {
            factoids.append(MovieFact(label: R.string.movieDetailsView.runtime(),
                                      value: "\(runtime) min"))
        }
        
        if let generes = movie?.genres {
            let value = generes
                .map({ $0.name })
                .joined(separator: ", ")
            factoids.append(MovieFact(label: R.string.movieDetailsView.generes(),
                                      value: value))
        }

        if let companies = movie?.productionCompanies {
            let value = companies
                .map({ $0.name })
                .joined(separator: ", ")
            factoids.append(MovieFact(label: R.string.movieDetailsView.productionCompanies(),
                                      value: value))
        }

        if let generes = movie?.productionCountries {
            let value = generes
                .map({ $0.name })
                .joined(separator: ", ")
            factoids.append(MovieFact(label: R.string.movieDetailsView.productionCountries(),
                                      value: value))
        }
    }

    var imdbUrl: URL? {
        guard let imdbId = movie?.imdbId else { return nil }
        return URL(string: "https://www.imdb.com/title/\(imdbId)/")
    }
}
