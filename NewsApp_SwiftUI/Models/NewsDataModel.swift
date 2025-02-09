//
//  NewsDataModel.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 30/01/25.
//

import Foundation


struct NewsData: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable,Identifiable {
    var id: String { url ?? UUID().uuidString }
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    
    var isBookmarked : Bool = false
    
    enum CodingKeys : String, CodingKey {
        case author, title, description, url, urlToImage
    }
}

struct Bookmark {
    let id : String
    let isBookmarked : Bool
}
