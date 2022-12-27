//
//  PhotoDetailView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/27.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ImageView(url: photo.urls.regular)
            .navigationTitle(photo.user.name)
    }
}
