//
//  ModeratorCellViewModel.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

protocol ModeratorCellViewModelProtocol {
    var displayName: String? { get }
    var reputation : String? { get }
}

struct ModeratorCellViewModel: ModeratorCellViewModelProtocol {
    
    var displayName: String?
    var reputation: String?
    
    init() {
        displayName = String()
        reputation = String()
    }
    
    init(with moderator: Moderator?) {
        displayName = moderator?.displayName
        reputation = moderator?.reputation
    }
}
