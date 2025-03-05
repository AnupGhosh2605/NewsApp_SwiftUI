//
//  NewsListRow.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 30/01/25.
//

import SwiftUI

struct NewsListRow: View {
    
    @State var newsItemData : Article
    @StateObject var newsImageVM : NewsImageViewModel
    @State private var navigateToWebView = false
    let isOfflineData: Bool
    var coreDataManager : CoreNewsDataManager


    init(newsItemData: Article,isOfflineData: Bool,coreDataManager : CoreNewsDataManager = CoreNewsDataManager.instance) {
        self.isOfflineData = isOfflineData
        self.newsItemData = newsItemData
        self.coreDataManager = coreDataManager

        _newsImageVM = StateObject(wrappedValue: NewsImageViewModel(article: newsItemData))
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                center
                buttom
                
            }
            .background(
                Color.secondary.opacity(0.001)
                
                    .navigationDestination(isPresented: $navigateToWebView) {
                        WebViewContainer(newsItemData: newsItemData)
                    }
            )
        }
        
    }
}

#Preview {
    NewsListRow(newsItemData: DeveloperPreview.instance.article, isOfflineData: false)
}




extension NewsListRow {
    
    // Title
    private var heading : some View {
        HStack {
            Text(newsItemData.title ?? "")
                .font(.headline)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            
            
            // add delete button
            if isOfflineData {
                Button(action: {
                    coreDataManager.deleteEntity(id: newsItemData.id)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button styling
                .padding(.leading, 8)
            }
        }
    }
    
    // Image and Description
    private var center : some View {
        
        HStack(alignment: .top , spacing: 8) {
            
            if let image = newsImageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 150, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
            else if newsImageVM.isLoading {
                ProgressView()
            }
            else {
                Image("DefaultImage")
                    .resizable()
                    .frame(width: 150, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
            
            VStack {
                heading
                
                Text(newsItemData.description ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.primary).opacity(0.6)
                    .lineLimit(3)
            }
        }
    }
    
    // Author and Bookmark
    private var buttom : some View {
        HStack {
            Spacer()
            Text("Read more…")
                .font(.subheadline)
                .foregroundColor(.blue)
                .onTapGesture {
                    navigateToWebView = true  // Push WebView when tapped
                }
        }
        .padding(.horizontal)
    }
    
}

