//
//  WebView.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 31/01/25.
//

import Foundation
import WebKit
import SwiftUI

struct WebViewContainer: View {
    let newsItemData : Article
    @StateObject private var OfflineListVM = OfflineListViewModel()
    @State private var navigateToOfflineList = false  // State for navigation
    
    var body: some View {
        ZStack {
            WebView(url: URL(string: newsItemData.url ?? "") ?? URL(fileURLWithPath: ""))  // Embedded WebView
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        saveWebpage()
                    }) {
                        Text("Save")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                }
            }
            .navigationDestination(isPresented: $navigateToOfflineList) {
                offlineList() // Navigate after saving
            }
            
        }
        .navigationTitle("Web View")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Function to handle save action
    private func saveWebpage() {
        OfflineListVM.addNewsDataToCoreData(data: newsItemData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            navigateToOfflineList = true // Navigate after saving
        }
    }
}

// WebView Implementation
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

