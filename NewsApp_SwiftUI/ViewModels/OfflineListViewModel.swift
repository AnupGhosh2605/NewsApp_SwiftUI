//
//  OfflineListViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 05/03/25.
//

import Foundation
import SwiftUI
import Combine
import CoreData


class OfflineListViewModel : ObservableObject {
    
    var coreDataManager : CoreNewsDataManager
    
    @Published var OfflinenewsData : NewsData?
    
    private var cancellables  = Set<AnyCancellable>()
    
    
    
    init(coreDataManager : CoreNewsDataManager = CoreNewsDataManager.instance){
        self.coreDataManager = coreDataManager
        self.coreDataManager.FetchNewsFromCoreData()
        addSubscriber()
    }
    
    private func addSubscriber(){
        coreDataManager.$newsPublisher
            .sink { newsData in
                DispatchQueue.main.async {
                    self.formatNewsData(data: newsData ?? [])
                }
            }
            .store(in: &cancellables)
    }
    
    
     func addNewsDataToCoreData(data : Article) {
        coreDataManager.addEntity(article: data)
    }
    
    
    private func formatNewsData(data : [ArticleEntity]){
        
        let mappedArticle = data.compactMap { entity -> Article? in
            let title = entity.title
            let description = entity.desc
            let url = entity.url
            let urlToImage = entity.urlToImage
            let author = entity.author
            _ = entity.id
            
            return Article(author: author, title: title, description: description, url: url, urlToImage: urlToImage)
            
        }
        
        let news = NewsData(status: "ok", totalResults: mappedArticle.count, articles: mappedArticle)
        DispatchQueue.main.async {
            self.OfflinenewsData = news
        }
        
    }
    
}
