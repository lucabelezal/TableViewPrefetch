//
//  Coin.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct CoinList: Decodable {
    let data: [String: Coin]
}

struct Coin: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let rank: Int
    let quotes: [String: Price]
}

struct Price: Decodable {
    let price: Double
}
