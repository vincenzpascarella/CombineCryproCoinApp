//
//  CoinGeckoAPI.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation

// MARK: - CoinResponse
struct CoinResponse: Codable {
    let coins: [Coin]
    
    // MARK: - Coin
    struct Coin: Codable {
        let id, name, apiSymbol, symbol: String
        let marketCapRank: Int?
        let thumb, large: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case apiSymbol = "api_symbol"
            case symbol
            case marketCapRank = "market_cap_rank"
            case thumb, large
        }
    }
}

