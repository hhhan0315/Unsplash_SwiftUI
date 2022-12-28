//
//  SearchResponseDTO.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/28.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let results: [PhotoResponseDTO]
}
