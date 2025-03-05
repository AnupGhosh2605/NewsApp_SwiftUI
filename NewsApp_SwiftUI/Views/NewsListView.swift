//
//  NewsListView.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 30/01/25.
//

import SwiftUI
import Combine

struct NewsListView: View {
    
    @StateObject private var newsVM =  NewsViewModel()
    @State private var isLinkActive = false
    @State private var selectedUrl : URL?
    
    
    var body: some View {
        NavigationStack {
            List {
                if let articles = newsVM.newsData?.articles, !articles.isEmpty {
                    
                    NewsListFirstRowView(newsItemData: articles[0])
                    
                    ForEach(articles.dropFirst()) { item in
                        NewsListRow(newsItemData: item, isOfflineData: false)
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavBarTitle)
            
        }
        
        
        
    }
}


#Preview {
    NewsListView()
}
