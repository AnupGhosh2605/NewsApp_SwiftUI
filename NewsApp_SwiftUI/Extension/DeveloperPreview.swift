//
//  DeveloperPreview.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import Foundation

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() { }
    
    let article = Article(
        author: "Amanda Gerut",
        title : "Elon Musk claims full self driving is so advanced Tesla owners are turning it off and steering with their knees to check text messages - Fortune",
        description: "The advanced driver assistance feature beeps when people take their hands off the steering wheel.",
        url: "https://fortune.com/2025/01/29/elon-musk-full-self-driving-tesla-earnings-texts-steering-email-beeps/",
        urlToImage: "https://fortune.com/img-assets/wp-content/uploads/2025/01/GettyImages-2194387923-e1738197194471.jpg?resize=1200,600"
        
        )
}
