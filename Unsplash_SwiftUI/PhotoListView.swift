//
//  PhotoListView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/27.
//

import SwiftUI
import Combine

struct PhotoListView: View {
    @State private var photos: [Photo] = []
    @State private var page = 0
    @State private var isLoading = false
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(photos, id: \.self) { photo in
                        NavigationLink {
                            PhotoDetailView(photo: photo)
                        } label: {
                            ImageView(url: photo.urls.regular)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width)
                        .progressViewStyle(.circular)
                        .onAppear {
                            fetchPhotos()
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Unsplash")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func fetchPhotos() {
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        self.page += 1
        let photoRequestDTO = PhotoRequestDTO(page: self.page)
        
        guard let urlRequest = API.getListPhotos(photoRequestDTO).urlRequest else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: [PhotoResponseDTO].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .sink { photoResponseDTOs in
                let photos = photoResponseDTOs.map { $0.toDomain() }
                self.photos += photos
                self.isLoading = false
            }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
