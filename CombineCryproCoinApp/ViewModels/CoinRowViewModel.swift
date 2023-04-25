//
//  CoinRowViewModel.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation
import Combine

class CoinRowViewModel: Identifiable {
    
    private let coin: CoinResponse.Coin
    
    var name: String {
        return coin.name
    }
    
    var marketCapRank: Int {
        guard let marketCapRank = coin.marketCapRank else { return 0 }
        return marketCapRank
    }
    
    init(coin: CoinResponse.Coin) {
        self.coin = coin
    }
}
