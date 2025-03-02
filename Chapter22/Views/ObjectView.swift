//
//  ObjectView.swift
//  Chapter22
//
//  Created by Louise Rennick on 2025-02-19.
//

import SwiftUI

struct ObjectView: View {
    let object: Object
    
    var body: some View {
        ZStack {
            Color("Color 7").ignoresSafeArea()
            VStack {
                if let url = URL(string: object.objectURL) {
                    Link(destination: url) {
                        WebIndicatorView(title: object.title)
                            .multilineTextAlignment(.leading)
                            .font(.callout)
                            .frame(minHeight: 44)
                        // add these four modifiers
                            .padding()
                            .background(Color ("Color 5"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text(object.title)
                        .multilineTextAlignment(.leading)
                        .font(.callout)
                        .frame(minHeight: 44)
                }
                
                if object.isPublicDomain {
                    AsyncImage(url: URL(string: object.primaryImageSmall)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        PlaceholderView(note: "Display image here")
                    }
                } else {
                    PlaceholderView(note: "Not in public domain. URL not valid.")
                }
                
                Text(object.creditLine)
                    .font(.caption)
                    .padding()
                    .background(Color("Color 5"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Divider()
                GalleryView (images: object.galleryImages)
            }
            .padding(.vertical)
        }
    }
}
struct ObjectView_Previews: PreviewProvider {
  static var previews: some View {
    ObjectView(
      object:
        Object(
          objectID: 28263,
          title: "An Esquimaux",
          creditLine: "Gift of Arthur A. Houghton Jr., 1970",
          objectURL: "https://collections.rom.on.ca/internal/media/dispatcher/28263/preview",
          isPublicDomain: true,
          primaryImageSmall:
            "https://collections.rom.on.ca/internal/media/dispatcher/28263/preview",
          galleryImages: [

                              "https://example.com/image1.jpg",

                              "https://example.com/image2.jpg",

                              "https://example.com/image3.jpg"

                          ]))
 
  }
}

struct PlaceholderView: View {
  let note: String
  var body: some View {
    ZStack {
      Rectangle()
        .inset(by: 7)
        .fill(Color.romForeground)
        .border(Color.romBackground, width: 7)
        .padding()
      Text(note)
        .foregroundColor(.romBackground)
    }
  }
}
