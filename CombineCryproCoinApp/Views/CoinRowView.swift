//
//  CoinRowView.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import SwiftUI

struct CoinRowView: View {
    
    private let viewModel: CoinRowViewModel

    init(viewModel: CoinRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.title3)
            
            if viewModel.marketCapRank != 0 {
                Text("Market Cap Rank: \(viewModel.marketCapRank)")
            } else {
                Text("Market Cap Rank: undefined")
            }
        }
    }
}
