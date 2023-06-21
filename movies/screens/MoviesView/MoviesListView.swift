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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .navigationTitle(viewModel.pageTitle)
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(viewModel: MoviesListViewModelImpl())
    }
}
