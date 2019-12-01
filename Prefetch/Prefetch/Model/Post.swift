//
//  Post.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct Post: Decodable {

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case postID = "id"
        case title
        case body
    }
    
    let userID: Int
    let postID: Int
    let title: String
    let body: String
}
