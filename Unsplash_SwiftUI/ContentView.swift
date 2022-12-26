//
//  ContentView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/16.
//

import SwiftUI

class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    private var page = 0
    
    private let networkService = NetworkService()
    
    func fetchPhotos() {
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        self.page += 1
        let photoRequestDTO = PhotoRequestDTO(page: self.page)
        
        networkService.request(api: API.getListPhotos(photoRequestDTO), dataType: [PhotoResponseDTO].self) { [weak self] result in
            switch result {
            case .success(let photoResponseDTOs):
                DispatchQueue.main.async {
                    let photos = photoResponseDTOs.map { $0.toDomain() }
                    self?.photos += photos
                    self?.isLoading = false
                }
            case .failure(let networkError):
                print(networkError.rawValue)
            }
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var photoListViewModel = PhotoListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(photoListViewModel.photos, id: \.self) { photo in
                        AsyncImage(url: URL(string: photo.urls.regular)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            EmptyView()
                        }
                    }
                    
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width)
                        .progressViewStyle(.circular)
                        .onAppear {
                            photoListViewModel.fetchPhotos()
                        }
                }
                .navigationTitle("Unsplash")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
