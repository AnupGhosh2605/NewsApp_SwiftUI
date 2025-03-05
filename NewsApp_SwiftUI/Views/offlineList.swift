//
//  offlineList.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 04/03/25.
//

import SwiftUI

struct offlineList: View {
    
    @StateObject private var OfflineListVM = OfflineListViewModel()
    
    
    var body: some View {
        NavigationStack {
            List {
                if let articles = OfflineListVM.OfflinenewsData?.articles, !articles.isEmpty {
                    
                    ForEach(articles) { item in
                        NewsListRow(newsItemData: item, isOfflineData: true)
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.OfflineListTitle)
        }
        
    }
}

#Preview {
    offlineList()
}
