//
//  MoviesViewModel.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

protocol MoviesListViewModel: ObservableObject {
    //MARK: Display fields
    var pageTitle: String { get }
}

class MoviesListViewModelImpl: MoviesListViewModel {
    //MARK: Display fields
    @Published
    var pageTitle: String = R.string.moviesListView.pageTitle()
}
