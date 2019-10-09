//
//  ImageDataStore.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

internal class RobohashService {

    private var robohashData: [Robohash] = (1...200).map { index in
        return Robohash(url: "https://robohash.org/\(index).png", order: index)
    }

    internal var numberOfImage: Int {
        return robohashData.count
    }
    
    internal func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<robohashData.count).contains(index) {
            return DataLoadOperation(robohash: robohashData[index])
        }
        return .none
    }
}
