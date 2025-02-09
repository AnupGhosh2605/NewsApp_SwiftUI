//
//  NewsImageViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import Foundation
import SwiftUI

class NewsImageViewModel : ObservableObject {
    
    
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    
    private let networkService : NetworkServices
    private let article : Article
    
    init(article : Article,networkService : NetworkServices = NetworkServices.instance){
        self.article = article
        self.networkService = networkService
        self.isLoading = true
        self.downloadImage()
        
    }
    
    private func downloadImage() {
        networkService.downloadData(urlString: article.urlToImage ?? "") { result in
            switch result {
            case .success(let data):
                self.image = UIImage(data: data)
            case .failure:
                print("Image Download failed")
            }
            self.isLoading = false
        }
    }
}

