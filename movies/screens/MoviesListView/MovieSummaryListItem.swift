//
//  MovieSummaryListItem.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import SwiftUI
import Kingfisher

struct MovieSummaryListItem: View {

    var summary: MovieSummary

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                KFImage(URL(string: "\(TheMovieDB.image(width: 200).prefix)\(summary.posterPath)")!)
                    .resizable()
                    .cacheMemoryOnly() //makes dev abit easier
                    .frame(width: 60, height: 90)
                    .border(.secondary)
                    .clipped()

                VStack (alignment: .leading) {
                    Text(summary.title)
                        .font(.title2)
                        .lineLimit(1)

                    Spacer()
                    Text(summary.overview)
                        .font(.caption)
                        .lineLimit(2)
                    Spacer()

                    HStack (spacing: 20){
                        Label(summary.originalLanguage.uppercased(), systemImage: "globe")
                            .imageScale(.small)
                            .font(.caption2)
                            .labelStyle(.titleAndIcon)
                            .foregroundColor(.gray)

                        Label("\(String(summary.voteCount))", systemImage: "checkmark")
                            .imageScale(.small)
                            .font(.caption2)
                            .labelStyle(.titleAndIcon)
                            .foregroundColor(.gray)

                        Spacer()

                        Text(summary.releaseDate, format: Date.FormatStyle().year().month().day())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 90)
            .padding(10)
        }
        .background(
            KFImage(URL(string: "\(TheMovieDB.image(width: 200).prefix)\(summary.backdropPath)")!)
                .resizable()
                .cacheMemoryOnly() //makes dev abit easier
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
        )
        .clipped()
    }
}

#if DEBUG
struct MovieSummaryListItem_Previews: PreviewProvider {
    static var previews: some View {
        MovieSummaryListItem(summary: MovieSummary.preview)
            .previewLayout(.sizeThatFits)
    }
}
#endif
