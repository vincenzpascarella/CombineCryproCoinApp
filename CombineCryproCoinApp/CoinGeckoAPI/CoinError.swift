//
//  CoinError.swift
//  CombineCryproCoinApp
//
//  Created by Vincenzo Pascarella on 24/04/23.
//

import Foundation

enum CoinError: Error {
  case parsing(description: String)
  case network(description: String)
}
