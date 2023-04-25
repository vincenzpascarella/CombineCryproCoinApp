//
//  HomeView.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                    searchField
                List {
                    if viewModel.coinsData.isEmpty{
                        noResult
                    } else {
                        coinsList
                    }
                }
                }
            .navigationTitle("Coins Market Cap Ranks")
            .navigationBarTitleDisplayMode(.inline)
        }//NavigationStack
    }
}

private extension HomeView {
    
    /// The search field view where users can input search queries to find coins.
    var searchField: some View {
        HStack {
            /// The `$` symbol transforms `searchText` into a `Binding<String>`. This is achievable because `HomeViewModel` conforms to the `ObservableObject` protocol and is stated using the `@ObservedObject` property wrapper.
            /// The `HomeViewModel` properties can still be utilized and retrieved without any bindings. When you don't need to make any change on them.
            TextField("Search coins", text: $viewModel.searchText)
                .padding()
                .background(Color.white)
        }
        .padding(.vertical)
        .background(Color(UIColor.systemGray6))
    }
    
    /// A computed property that returns a list of coins. The list is generated using a `ForEach` loop and the `viewModel.coinsData` property.
    var coinsList: some View {
        Section {
            /// A `ForEach` loop that generates a `CoinRowView` for each `CoinViewModel` object in the `viewModel.coinsData` property.
            ForEach(viewModel.coinsData) { coin in
                CoinRowView.init(viewModel: coin)
            }
        }
    }
    
    /// A computed property that returns a message when there are no search results.
    var noResult: some View {
        Section {
            Text("No results, try searching something else")
                .foregroundColor(.gray)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(coinFetcher: CoinFetcher()))
    }
}
