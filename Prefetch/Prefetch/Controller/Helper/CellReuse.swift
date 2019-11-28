//
//  NibKey.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

public enum CellReuse {
    case post
    case news
    case loading
    case coin

    var name: String {
        switch self {
        case .post:
            return "PostTableViewCell"
        case .news:
            return "NewsTableViewCell"
        case .loading:
            return "LoadingTableViewCell"
        case .coin:
            return "CoinTableViewCell"
        }
    }

    var identifier: String {
        switch self {
        case .post:
            return "postCell"
        case .news:
            return "newsCell"
        case .loading:
            return "loadingCell"
        case .coin:
            return "coinCell"
        }
    }

}
