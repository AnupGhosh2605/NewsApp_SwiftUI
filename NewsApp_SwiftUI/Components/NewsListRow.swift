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
    @StateObject private var newsVM =  NewsViewModel()

    @State var isBookmarked : Bool
    
    init(newsItemData: Article) {
        self.newsItemData = newsItemData
        isBookmarked = newsItemData.isBookmarked
        _newsImageVM = StateObject(wrappedValue: NewsImageViewModel(article: newsItemData))
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            top
            center
            buttom
        }
        .background(
            Color.secondary.opacity(0.001)
        )

    }
}

#Preview {
    NewsListRow(newsItemData: DeveloperPreview.instance.article)
}




extension NewsListRow {
    
    // Title
    private var top : some View {
        Text(newsItemData.title ?? "")
            .font(.headline)
    }
    
    // Image and Description
    private var center : some View {
        
        HStack(alignment: .top , spacing: 8) {
            ZStack {
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
            }
            
            
            
            Text(newsItemData.description ?? "")
                .font(.callout)
                .foregroundStyle(.primary).opacity(0.6)
                .lineLimit(4)
          
        }
    }
    
    // Author and Bookmark
    private var buttom : some View {
        HStack {
            if let author = newsItemData.author {
                HStack(alignment: .top , spacing: 5){
                    Text("AUTHOR :")
                        .foregroundStyle(.orange)
                    Text(author.uppercased())
                }
                .font(.caption)
                .bold()
            }
            
             Spacer()
            
            
            // Bookmark button is not tapable
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

