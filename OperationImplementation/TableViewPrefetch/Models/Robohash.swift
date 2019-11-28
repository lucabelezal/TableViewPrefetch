//
//  Robohash.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

public struct Robohash {

    public private(set) var url: URL?
    private let order: Int
    
    public init(url: String?, order: Int) {
        self.url = url?.toURL
        self.order = order
    }
}
