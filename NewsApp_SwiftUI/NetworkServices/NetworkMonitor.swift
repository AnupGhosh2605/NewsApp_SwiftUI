//
//  NetworkMonitor.swift
//  NewsApp_SwiftUI
//
//  Created by Anup Ghosh on 05/03/25.
//

import Foundation
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true // Default to true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
