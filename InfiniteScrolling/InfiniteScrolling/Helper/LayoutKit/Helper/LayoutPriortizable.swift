//
//  LayoutPriortizable.swift
//  LayoutKit
//
//  Created by Vinicius França on 30/09/18.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

public enum LayoutPriortizable: Float {
    case low = 250.0
    case medium = 500.0
    case high = 750.0
    case required = 999.0

    internal var priorityValue: LayoutPriority {
        return LayoutPriority(rawValue: self.rawValue)
    }
}
