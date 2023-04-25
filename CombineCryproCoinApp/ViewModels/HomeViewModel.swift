//
//  HomeViewModel.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation
import Combine

/// Make `HomeViewModel` conform with `ObservableObject` and `Identifiable`. Conforming to these protocols implies that the properties of `HomeViewModel` can be utilized as bindings.
class HomeViewModel: ObservableObject, Identifiable {
    
    /// A published property that holds the search text entered by the user.
    ///
    /// Publishing a property with the `@Published` attribute creates a `Publisher` of this type that makes it possible to observe the `searchText` property
    @Published var searchText: String = ""
    
    ///  A published property that holds the array of coin row view models to display.
    ///
    ///  The `ViewModel` will store the data source for the View. This is different from what you might have done in MVC. The property has the `@Published` attribute, so the compiler creates a `Publisher` for it automatically. `SwiftUI` subscribes to that `Publisher` and updates the screen when you modify the property
    @Published var coinsData: [CoinRowViewModel] = []
    
    private let coinFetcher: CoinFetcher
    
    /// A collection of `AnyCancellable` instances that can be used to keep references to network requests.
    ///
    /// Consider `cancellables` as a group of references to requests. If you don’t retain these references, the network requests you make will not persist, preventing you from receiving server responses.
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes a new HomeViewModel instance.
    /// - Parameters:
    ///  - coinFetcher: The coin fetcher used to get the list of coins from the API.
    ///  - scheduler: The DispatchQueue used to schedule the API requests. Use it to specify the queue that the HTTP request will use.
    init(
        coinFetcher: CoinFetcher,
        scheduler: DispatchQueue = DispatchQueue(label: "HomeViewModel")
    ) {
        self.coinFetcher = coinFetcher
        
        /// The `searchText` property sets up a `Publisher`. It can be observed and can utilize any method available to `Publisher`.
        /// Sets up a `Publisher` to emit a search text value after a certain interval and trigger a fetchCoin() call with that value.
        $searchText
        
        /// Use `debounce(for:scheduler:)` to enhance the user experience. Otherwise, `fetchCoin` would initiate a new HTTP request for each character entered. Debounce waits for 0.5 seconds until the user stops typing before sending a value. The `scheduler` argument specifies the queue on which emitted values will be processed.
            .debounce(for: .seconds(0.5), scheduler: scheduler)
        
        /// Observe events via `sink(receiveValue:)` and handle them with `fetchCoin(forCoin:)`
            .sink(receiveValue: fetchCoin(forCoin:))
        
        /// Include the cancellable reference in the `cancellables` set. If this reference is not kept alive, the network publisher will cease immediately.
            .store(in: &cancellables)
    }
    
    
    /// Sends a request to the API for a given coin and updates the coinsData property with the returned data.
    /// - Parameter coin: The coin to search for.
    func fetchCoin(forCoin coin: String) {
        
        /// Initiate a new request to retrieve data from the CoinGecko API. Provide the coin name as an argument.
        coinFetcher.coins(with: coin)
        
        /// map the `CoinResponse` into an array of `CoinRowViewModel`.
            .map { response in
                response.coins.map(CoinRowViewModel.init)
            }
        
        /// While data retrieval from the server or `JSON` parsing occurs on a background queue, `UI` updates must happen on the `main` queue. Using `receive(on:)`, you ensure that the updates take place in the correct location.
            .receive(on: DispatchQueue.main)
        
        /// Initiate the `Publisher` using `sink(receiveCompletion:receiveValue:)`, where you update `coinsData` accordingly. Note that handling a completion, whether successful or failed, occurs separately from handling values.
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    /// If a failure occurs, set `coinsData` to an empty array.
                    self.coinsData = []
                case .finished:
                    break
                }
                
            },
            receiveValue: { [weak self] coin in
                guard let self = self else { return }
                /// Update `coinsData` when a new coin arrives
                self.coinsData = coin
            })
        
        /// Include the cancellable reference in the `cancellables` set. If this reference is not kept alive, the network publisher will cease immediately.
            .store(in: &cancellables)
    }
}
