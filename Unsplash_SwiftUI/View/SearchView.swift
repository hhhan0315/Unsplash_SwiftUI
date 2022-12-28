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
    @State private var cancellable: AnyCancellable?
    
    @State private var columns: Int = 2
    
    var body: some View {        
        NavigationView {
            StaggeredGrid(columns: columns, list: photos, content: { photo in
                ImageView(url: photo.urls.regular)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        columns += 1
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        columns = max(columns - 1, 1)
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            .animation(.easeInOut, value: columns)
            .padding(.horizontal)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .onSubmit(of: .search) {
            print(searchText)
        }
    }
    
//    private func fetchPhotos() {
//        let photoRequestDTO = PhotoRequestDTO(page: 1)
//        
//        guard let urlRequest = API.getListPhotos(photoRequestDTO).urlRequest else {
//            return
//        }
//        
//        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .map { $0.data }
//            .decode(type: [PhotoResponseDTO].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .sink { photoResponseDTOs in
//                let photos = photoResponseDTOs.map { $0.toDomain() }
//                self.photos += photos
//            }
//    }
    
//    private func fetchTopics() {
//        let topicRequestDTO = TopicRequestDTO()
//
//        guard let urlRequest = API.getListTopics(topicRequestDTO).urlRequest else {
//            return
//        }
//
//        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .map { $0.data }
//            .decode(type: [TopicResponseDTO].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .sink { topicResponseDTOs in
//                let topics = topicResponseDTOs.map { $0.toDomain() }
//                self.topics = topics
//            }
//    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
