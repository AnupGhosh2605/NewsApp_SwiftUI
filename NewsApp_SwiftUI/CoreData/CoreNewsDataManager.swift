//
//  CoreNewsDataManager.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import Foundation
import CoreData
import Combine


class CoreNewsDataManager {
    

    static let instance = CoreNewsDataManager()
    
     let container : NSPersistentContainer
    
    @Published var newsPublisher : [ArticleEntity]?
    @Published var bookmarkPublisher : [BookmarkedEntity]?
    
    init() {
        container = NSPersistentContainer(name: "NewsDataContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error in loading the Container : \(error)")
            }
        }
    }
    
    func FetchNewsFromCoreData() {
//        Creating the Fetch Request
        let request : NSFetchRequest<ArticleEntity> = NSFetchRequest(entityName: "ArticleEntity")
        
        do {
            let res = try container.viewContext.fetch(request)
            newsPublisher = res

        } catch {
            print("Error in downloading data from Core data : \(error)")
        }
    }
    
    
    func FetchBookmarkedDataFromCoreData() {
        let request : NSFetchRequest<BookmarkedEntity> = NSFetchRequest(entityName: "BookmarkedEntity")
        
        do {
            let res = try container.viewContext.fetch(request)
            bookmarkPublisher = res
        } catch {
            print("Error in downloading data from Core data : \(error)")
        }
    }
    
    
    func addEntity(article : Article) {
        if isArticleAlreadyPresent(id: article.id) {
            return
        }
        
        let entity = ArticleEntity(context: container.viewContext)
        entity.id = article.id
        entity.title = article.title
        entity.author = article.author
        entity.desc = article.description
        entity.url = article.url
        entity.urlToImage = article.urlToImage
        
        saveData()
    }
    
    
//    func addBookmarkedEntity(entity : Bookmark) {
//        if !isIdAlreadyPresent(id: entity.id) {
//            return
//        }
//        let newEntity = BookmarkedEntity(context: container.viewContext)
//        newEntity.id = entity.id
//        newEntity.isBookmarked = entity.isBookmarked
//        
//        saveData()
//    }
    
    func isArticleAlreadyPresent(id : String) -> Bool {
        // Creating the Fetch Request
        let request : NSFetchRequest<ArticleEntity> = NSFetchRequest(entityName: "ArticleEntity")
        
        // "id == %@" used to fetch records where the id field in ArticleEntity matches the provided id argument.
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let count = try container.viewContext.count(for: request)
            return count > 0
        } catch {
            print("Failed to check duplicate :\(error.localizedDescription)")
            return false
        }
        
    }
    
//    func isIdAlreadyPresent(id : String) -> Bool {
//        // Creating the Fetch Request
//        let request : NSFetchRequest<BookmarkedEntity> = NSFetchRequest(entityName: "BookmarkedEntity")
//        
//        // "id == %@" used to fetch records where the id field in ArticleEntity matches the provided id argument.
//        request.predicate = NSPredicate(format: "id == %@", id)
//        do {
//            let count = try container.viewContext.count(for: request)
//            return count > 0
//        } catch {
//            print("Failed to check duplicate :\(error.localizedDescription)")
//            return false
//        }
//        
//    }
    
    
    func saveData(){
        do {
            try container.viewContext.save()
            let concurrentQueue = DispatchQueue(label: "com.dispatch",attributes: .concurrent)
            concurrentQueue.async {
                self.FetchNewsFromCoreData()
            }
            concurrentQueue.async {
                self.FetchBookmarkedDataFromCoreData()
            }
        } catch {
            print("Error in saving data to coredata : \(error)")
        }
    }
}
