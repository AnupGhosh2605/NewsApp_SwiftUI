//
//  NewsListFirstRowView.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import SwiftUI

struct NewsListFirstRowView: View {
    
    @State var newsItemData : Article
    
    @StateObject var newsImageVM : NewsImageViewModel
    @StateObject private var newsVM = NewsViewModel()
    
    @State var isBookmarked : Bool
    
    init(newsItemData: Article) {
        self.newsItemData = newsItemData
        self.isBookmarked = newsItemData.isBookmarked
        _newsImageVM = StateObject(wrappedValue: NewsImageViewModel(article: newsItemData))
    }
    
    var body: some View {
        VStack(alignment : .leading, spacing: 8) {
            
            TopView
            CenterView
            ButtomView
        }
        .background(
            Color.secondary.opacity(0.001)
        )
    }
}

#Preview {
    NewsListFirstRowView(newsItemData: DeveloperPreview.instance.article)
}


extension NewsListFirstRowView {
    private var TopView : some View {
        ZStack {
            if let image = newsImageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 250)
            }
            else if newsImageVM.isLoading {
                ProgressView()
            }
            else {
                Image("DefaultImage")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 250)
            }
        }
    }
    
    
    private var CenterView : some View {
        VStack(spacing : 4) {
            Text(newsItemData.title ?? "")
                .font(.headline)
            
            Text(newsItemData.description ?? "")
                .font(.callout)
                .foregroundStyle(.primary).opacity(0.6)
                .lineLimit(2)
        }
        
    }
    
    
    private var ButtomView : some View {
        
        HStack {
            HStack(alignment: .top , spacing: 5){
                Text("AUTHOR :")
                    .foregroundStyle(.orange)
                Text(newsItemData.author ?? "")
            }
            .font(.caption)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            
            Spacer()
            
            Button(action: {
                isBookmarked.toggle()
//                self.newsVM.toggleBookmark(for: newsItemData.id,bookmark: isBookmarked)
            }, label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .frame(width: 15, height: 20)
                    .foregroundStyle(isBookmarked ? .blue : .primary.opacity(0.7))
                    .padding()
            })
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.top)
        
    }
    
}
