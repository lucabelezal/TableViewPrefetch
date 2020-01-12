//
//  ModeratorsListViewModel.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import Foundation

protocol ModeratorsListViewModelProtocol {
    var totalCount: Int { get }
    var currentCount: Int { get }
    var moderator: (_ index: Int) -> ModeratorCellViewModelProtocol { get }
    var indexPathsToReload: [IndexPath]? { get }
}

struct ModeratorsListViewModel: ModeratorsListViewModelProtocol {

    var totalCount: Int
    var currentCount: Int
    var moderator: (Int) -> ModeratorCellViewModelProtocol
    var indexPathsToReload: [IndexPath]?
    
    init() {
        self.totalCount = 0
        self.currentCount = 0
        self.moderator = { _ in return ModeratorCellViewModel() }
    }
    
    init(data: ModeratorData, moderators: [Moderator]) {
        self.totalCount = data.total
        self.currentCount = moderators.count
        self.moderator = { index in
            return ModeratorCellViewModel(with: moderators[index])
        }
        
        if data.page > 1 {
            indexPathsToReload = ModeratorsListViewModel.calculateIndexPathsToReload(from: data.moderators, with: moderators)
        }
    }
    
    private static func calculateIndexPathsToReload(from newModerators: [Moderator], with allModerators: [Moderator]) -> [IndexPath] {
      let startIndex = allModerators.count - newModerators.count
      let endIndex = startIndex + newModerators.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
