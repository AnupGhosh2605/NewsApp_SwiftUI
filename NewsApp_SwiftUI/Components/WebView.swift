//
//  WebView.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import Foundation
import WebKit
import SwiftUI

struct WebView : UIViewRepresentable {

    let url : URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
        
    }
}
