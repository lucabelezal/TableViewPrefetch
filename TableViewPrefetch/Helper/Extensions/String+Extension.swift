//
//  String+Extension.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
