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
    
    init(networkService: NetworkServices = NetworkServices.instance,coreDataManager : CoreNewsDataManager = CoreNewsDataManager.instance) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        fetchNewsData()
        
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
    


    
    
    
}
