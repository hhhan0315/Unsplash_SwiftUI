//
//  ContentView.swift
//  Unsplash_SwiftUI
//
//  Created by rae on 2022/12/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PhotoListView()
                .tabItem {
                    Image(systemName: "photo.fill")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
