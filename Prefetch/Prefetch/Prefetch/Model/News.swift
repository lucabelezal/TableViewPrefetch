//
//  News.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct News: Decodable {
    let title: String
    let url: String?
    let by: String
}
