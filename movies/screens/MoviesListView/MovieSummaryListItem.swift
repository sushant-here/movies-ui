//
//  MovieSummaryListItem.swift
//  movies
//
//  Created by Sushant Verma on 22/6/2023.
//

import SwiftUI
import Kingfisher

struct MovieSummaryListItem: View {

    var summary: MovieSummary

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                KFImage(summary.posterUrl)
                    .resizable()
                    .cacheMemoryOnly() //makes dev abit easier
                    .frame(width: 60, height: 90)
                    .border(.secondary)

                VStack (alignment: .leading) {
                    Group {
                        if let title = summary.title {
                            Text(title)
                                .font(.title2)
                                .lineLimit(1)
                        }

                        if let overview = summary.overview {
                            Text(overview)
                                .font(.caption)
                                .lineLimit(2)

                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    HStack (spacing: 20){
                        if let language = summary.originalLanguage {
                            Label(language.uppercased(), systemImage: "globe")
                                .imageScale(.small)
                                .labelStyle(.titleAndIcon)
                        }

                        if let voteCount = summary.voteCount {
                            Label("\(String(voteCount))", systemImage: "checkmark")
                                .imageScale(.small)
                                .labelStyle(.titleAndIcon)
                        }

                        Spacer()

                        if let releaseDate = summary.releaseDate {
                            Text(releaseDate, format: Date.FormatStyle().year().month().day())
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.gray)
                }
            }
            .frame(height: 90)
            .padding(10)
        }
        .background(
            KFImage(summary.backdropUrl)
                .resizable()
                .cacheMemoryOnly() //makes dev abit easier
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.1)
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
