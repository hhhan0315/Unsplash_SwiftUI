//
//  PhotoSearchRequestDTO.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/20.
//

import Foundation

struct PhotoSearchRequestDTO {
    let query: String
    let page: Int
    let perPage: Int = 10
}
