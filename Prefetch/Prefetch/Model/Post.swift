//
//  Post.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct Post: Decodable {

    let userID: Int
    let postID: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case postID = "id"
        case title
        case body
    }

}
