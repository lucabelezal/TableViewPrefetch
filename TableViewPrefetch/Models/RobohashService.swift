//
//  ImageDataStore.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Rokon Uddin. All rights reserved.
//

import Foundation

internal class RobohashService {

    private var images = (1...200).map { index in
        return Robohash(url: "https://robohash.org/\(index).png", order: index)
    }

    internal var numberOfImage: Int {
        return images.count
    }
    
    internal func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<images.count).contains(index) {
            return DataLoadOperation(images[index])
        }
        return .none
    }
}
