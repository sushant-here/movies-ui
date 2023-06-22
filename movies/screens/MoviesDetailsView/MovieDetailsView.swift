//
//  MovieDetailsView.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView<Model>: View where Model: MovieDetailsViewModel {
    @ObservedObject var viewModel: Model

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView(viewModel.loadingMessage)
                    .controlSize(.large)
                    .foregroundColor(.accentColor)
                    .tint(.accentColor)
            } else {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg")!)
                            .resizable()
                            .cacheMemoryOnly()
                            .frame(width: 100, height: 150)
                            .border(.secondary)

                        VStack (alignment: .leading) {
                            Group {
                                Text("<<title>>")
                                    .font(.title)

                                Text("<<tagline>>")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)

                    }

                    Spacer().frame(height: 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("<<Release Date>>:")
                            Text("dd/mm/yy")
                        }
                        HStack {
                            Text("<<Revenue>>:")
                            Text("$##,###,###")
                        }
                        HStack {
                            Text("<<Runtime>>:")
                            Text("200 min#")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)


                    Spacer().frame(height: 10)
                    Button(action: openIMDB) {
                        Label("<<imdb>>", systemImage: "globe")
                    }
                }
                .padding()
            }
        }
        .frame(maxHeight: .infinity)
        .background(alignment: .center, content: {
            if viewModel.isLoading {
                EmptyView()
            } else {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500/1inZm0xxXrpRfN0LxwE2TXzyLN6.jpg")!)
                    .resizable()
                    .cacheMemoryOnly() //makes dev abit easier
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
            }
        })
        .navigationBarTitle("<<Details>>", displayMode: .inline)
        .onAppear(perform: viewModel.onAppear)
    }

    func openIMDB() {
        print("IMDB Action")
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
