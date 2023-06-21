//
//  MovieDetailsView.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI

struct MovieDetailsView: View {
    let movieId: Int

    var body: some View {
        Text("Hello, World!... \(movieId)")
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movieId: 123)
    }
}
