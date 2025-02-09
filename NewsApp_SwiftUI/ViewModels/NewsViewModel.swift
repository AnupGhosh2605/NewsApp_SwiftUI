//
//  NewsViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 30/01/25.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class NewsViewModel : ObservableObject {
    
    var networkService : NetworkServices
    var coreDataManager : CoreNewsDataManager
    
    @Published var newsData : NewsData?
    private var cancellables  = Set<AnyCancellable>()

    var article : Article?
    var bookmarkedList : [BookmarkedEntity] = []
    
    init(networkService: NetworkServices = NetworkServices.instance,coreDataManager : CoreNewsDataManager = CoreNewsDataManager.instance) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        addSubscriber()
        fetchNewsData()
        
    }
    
    private func addSubscriber(){
        Publishers.CombineLatest(coreDataManager.$newsPublisher, coreDataManager.$bookmarkPublisher)
            .sink { newsData, bookmarkedData in
                DispatchQueue.main.async {
                    self.formatNewsData(data: newsData ?? [],bookmarkData : bookmarkedData ?? [])
                }
            }
            .store(in: &cancellables)
    }
    
    // Func to fetch the news data by calling the method from Network Service
    func fetchNewsData() {
        networkService.downloadData(urlString: Constants.API_URL) { returnedNewsData in
            switch returnedNewsData {
            case .success(let data):
                self.decodeNewsData(data: data)
            case .failure(let failure):
                print("Error fetching data: \(failure)")
                self.coreDataManager.FetchNewsFromCoreData()
            }
        }
    }
    
    
    // Decode the news data to display in the view.
    private func decodeNewsData(data: Data) {
        self.networkService.Decode(data: data, type: NewsData.self) { decodedData in
            switch decodedData {
            case .success(let success):
                DispatchQueue.main.async {
                    self.newsData = success
                }
                // Adding to core data
                DispatchQueue.global(qos: .background).async {
                    self.addNewsDataToCoreData(data: success)
                }
            case .failure(let failure):
                print("Error decoding data: \(failure)")
                self.newsData = nil

            }
        }
    }
    
    
    
   
    
    // Fetch the image data from URL anc convert it to UIImage
    func fetchImageData(imageUrl : String,completion: @escaping (UIImage?) -> Void) {
        networkService.downloadData(urlString: imageUrl) { returnedImageData in
            switch returnedImageData {
            case .success(let data):
                if let image = UIImage(data: data) {
                    // Storing image with the key
                    completion(image)
                }
                else {
                    completion(nil)
                }
            case .failure(let failure):
                print("Error fetching imageData: \(failure)")
                completion(nil)
            }
        }
    }
    
    private func addNewsDataToCoreData(data : NewsData) {
        for item in data.articles ?? [] {
            coreDataManager.addEntity(article: item)
        }
    }
    func formatNewsData(data : [ArticleEntity],bookmarkData : [BookmarkedEntity]){
     
        var mappedArticle = data.compactMap { entity -> Article? in
              let title = entity.title
              let description = entity.desc
              let url = entity.url
              let urlToImage = entity.urlToImage
              let author = entity.author
              let id = entity.id
            
            
            let isBookmarked = bookmarkData.first { $0.id == id}?.isBookmarked ?? false
            return Article(author: author, title: title, description: description, url: url, urlToImage: urlToImage,isBookmarked: isBookmarked)
            
        }
                
        let news = NewsData(status: "ok", totalResults: mappedArticle.count, articles: mappedArticle)
        DispatchQueue.main.async {
            self.newsData = news
        }
        
    }
    
//    func toggleBookmark(for id : String, bookmark : Bool) {
//        coreDataManager.addBookmarkedEntity(entity: Bookmark(id: id,isBookmarked: bookmark))
//    }
    

    
    
    
}
