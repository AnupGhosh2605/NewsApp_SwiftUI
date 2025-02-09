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
                    
                    if let url = URL(string: articles[0].url ?? "") {
                        NewsListFirstRowView(newsItemData: articles[0])
                            .onTapGesture {
                                isLinkActive = true
                                selectedUrl = url
                            }
                    }
                    
                    ForEach(articles.dropFirst()) { item in
                        if let url = URL(string: item.url ?? "") {
                            NewsListRow(newsItemData: item)
                                .onTapGesture {
                                    isLinkActive = true
                                    selectedUrl = url
                                }
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isLinkActive) {
                if let selectedUrl {
                    WebView(url: selectedUrl)
                }
            }
           
            .navigationTitle(Constants.NavBarTitle)
            
        }
        
        
       
    }
}


#Preview {
    NewsListView()
}
