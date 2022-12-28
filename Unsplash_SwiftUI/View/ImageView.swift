//
//  ImageView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/27.
//

import SwiftUI

struct ImageView: View {
    @StateObject var imageLoader: ImageLoader
    
    init(url: String) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.load()
        }
    }
}
