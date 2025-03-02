//
//  GalleryView.swift
//  iOSApp3
//
//  Created by Fatima Bdair on 2025-03-02.
//

import SwiftUI

struct GalleryView: View {
    let images: [String]

    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)

                        case .empty:
                            ProgressView()

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
