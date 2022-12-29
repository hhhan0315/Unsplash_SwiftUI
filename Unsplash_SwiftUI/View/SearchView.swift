//
//  SearchView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/27.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State private var photos: [Photo] = []
    @State private var searchText = ""
    @State private var page = 0
    @State private var isLoading = false
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
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
                            fetchSearchPhotos()
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search Photos...")
        )
        .onSubmit(of: .search) {
            self.photos.removeAll()
            self.page = 0
            fetchSearchPhotos()
        }
    }
    
    private func fetchSearchPhotos() {
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        self.page += 1
        
        let photoSearchRequestDTO = PhotoSearchRequestDTO(query: self.searchText, page: self.page)
        
        guard let urlRequest = API.getSearchPhotos(photoSearchRequestDTO).urlRequest else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: SearchResponseDTO.self, decoder: JSONDecoder())
            .replaceError(with: SearchResponseDTO(results: []))
            .sink { searchResponseDTO in
                let photos = searchResponseDTO.results.map { $0.toDomain() }
                self.photos += photos
                self.isLoading = false
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
