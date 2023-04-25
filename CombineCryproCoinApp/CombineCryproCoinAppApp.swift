//
//  CombineCryproCoinAppApp.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import SwiftUI

@main
struct CombineCryproCoinAppApp: App {
    
    let viewModel = HomeViewModel(coinFetcher: CoinFetcher())
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
        }
    }
}
