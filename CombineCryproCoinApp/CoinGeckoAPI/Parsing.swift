//
//  Parsing.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation
import Combine

/// The `decode` function decodes a data object containing `JSON` data into an instance of the specified `Decodable` type `T`.
///
/// - Parameters:
///    - data: The data object to be decoded.
/// - Returns: A `Publisher` that emits an instance of the specified Decodable type `T` or an error of type `CoinError`.
func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, CoinError> {
    
    /// `JSONDecoder` object used to decode the `JSON` data.
    let decoder = JSONDecoder()
    
    /// Sets the date decoding strategy to convert `Unix` timestamps to `Date` objects.
    decoder.dateDecodingStrategy = .secondsSince1970
    
    /// Returns a `Publisher` that emits the decoded object of type `T` or an error of type `CoinError`.
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
}
