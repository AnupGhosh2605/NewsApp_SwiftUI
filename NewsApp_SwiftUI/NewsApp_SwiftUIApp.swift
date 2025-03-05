//
//  NewsApp_SwiftUIApp.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 30/01/25.
//

import SwiftUI
import Network


@main
struct NewsApp_SwiftUIApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()

        var body: some Scene {
            WindowGroup {
                if networkMonitor.isConnected {
                    NewsListView()
                } else {
                    offlineList()
                }
            }
        }
}
