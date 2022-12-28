//
//  StaggeredGrid.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/28.
//

import SwiftUI

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    var content: (T) -> Content
    
    var list: [T]
    
    var columns: Int
    
    var showIndicators: Bool
    var spacing: CGFloat
    
    init(columns: Int, showIndicators: Bool = false, spacing: CGFloat = 10, list: [T],  @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showIndicators = showIndicators
        self.columns = columns
    }
    
    func setupList() -> [[T]] {
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex = 0
        
        for object in list {
            gridArray[currentIndex].append(object)
            
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        
        return gridArray
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showIndicators) {
            HStack(alignment: .top) {
                ForEach(setupList(), id: \.self) { columnsData in
                    LazyVStack(spacing: spacing) {
                        ForEach(columnsData) { object in
                            content(object)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct StaggeredGrid_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
