//
//  ModeratorData.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct ModeratorData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case moderators = "items"
        case hasMore = "has_more"
        case total
        case page
    }
    
    let moderators: [Moderator]
    let hasMore: Bool
    let total, page: Int
}
