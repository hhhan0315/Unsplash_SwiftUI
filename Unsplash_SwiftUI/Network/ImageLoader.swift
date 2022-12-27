//
//  ImageLoader.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/27.
//

import UIKit
import Combine

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let url: String
    private var cancellable: AnyCancellable?
    
    init(url: String) {
        self.url = url
    }
    
    func load() {
        guard let url = URL(string: url) else {
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }
}
