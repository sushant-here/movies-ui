//
//  moviesApp.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI

@main
struct moviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesListView(viewModel: MoviesListViewModelImpl())
            }
        }
    }
}
