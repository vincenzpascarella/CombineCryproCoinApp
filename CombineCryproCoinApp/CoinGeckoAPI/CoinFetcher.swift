//
//  CoinFetcher.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation
import Combine

/// The CoinFetchable protocol defines the method used to fetch coin data from the network.
protocol CoinFetchable {
    /// Fetches a list of coins that match the given search text.
    ///
    /// - Parameter text: The search text to use when querying the CoinGecko API.
    /// - Returns: A `Publisher` that emits either a `CoinResponse` or a `CoinError` when the network request completes.
    func coins(with text: String) -> AnyPublisher<CoinResponse, CoinError>
}

/// The `CoinFetcher` class is responsible for handling network requests for coin data.
class CoinFetcher {
    
    private let session: URLSession
    
    /// Initializes a new instance of `CoinFetcher`.
    
    /// - Parameter session: The `URLSession` object to use for making network requests.
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension CoinFetcher: CoinFetchable {
    func coins(with text: String) -> AnyPublisher<CoinResponse, CoinError> {
        return coinData(with: makeCoinGeckoComponents(with: text))
    }
    
    private func coinData<T>(with components: URLComponents) -> AnyPublisher<T, CoinError> where T: Decodable {
        
        /// Generate a `URL` instance using the `URLComponents`. In case of failure, wrap the error in a `Fail` value.
        guard let url = components.url else {
            let error = CoinError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        /// Fetch data from the network and handle any errors that occur.
        /// Utilize the recently introduced `URLSession` function, `dataTaskPublisher(for:)`, to acquire the data. This function accepts a `URLRequest` object and can yield either a tuple containing `(Data, URLResponse)` or a `URLError`.
        return session.dataTaskPublisher(for: URLRequest(url: url))
        /// Using `.mapError(_:)` You can convert the error from `URLError` to `CoinError` by mapping it, since the method returns `AnyPublisher<T, CoinError>`.
            .mapError { error in
                    .network(description: error.localizedDescription)
            }
        /// Decodes the received `JSON` data to the generic type `T`. `decode(_:)` is used as a helper function to accomplish this.
        /// To retrieve only the first value emitted by the network request, `.max(1)` is set.
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
        /// Erases the generic types returned by `flatMap` and returns the `Publisher` as an `AnyPublisher`.
        /// This approach enhances the usability of the API, and it is also beneficial because the addition of any new transformation can change the return type and expose implementation details.
            .eraseToAnyPublisher()
    }
}

// MARK: - CoinGecko API

private extension CoinFetcher {
    
    /// A struct containing CoinGecko API constants.
    struct CoinGeckoAPI {
        static let scheme = "https"
        static let host = "api.coingecko.com"
        static let path = "/api/v3/search"
    }
    
    /// Constructs the `URLComponents` object for making a CoinGecko API request.
    ///
    /// Use this method to construct the URL components for a CoinGecko API request with the provided search query.
    ///
    /// - Parameter text: The search query text to match against coin names or symbols.
    ///
    /// - Returns: A `URLComponents` object representing the endpoint for a CoinGecko API request.
    func makeCoinGeckoComponents(with text: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = CoinGeckoAPI.scheme
        components.host = CoinGeckoAPI.host
        components.path = CoinGeckoAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "query", value: text)
        ]
        
        return components
    }
}
