//
//  Moderator.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct Moderator: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case reputation
    }
    
    let displayName, reputation: String
    
    init(displayName: String, reputation: String) {
        self.displayName = displayName
        self.reputation = reputation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let reputation = try container.decode(Double.self, forKey: .reputation)
        self.init(displayName: displayName.htmlToString, reputation: reputation.formatted)
    }
}
