//
//  ModeratorsViewModel.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 10/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

import Foundation

protocol ModeratorsViewModelDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {

  private weak var delegate: ModeratorsViewModelDelegate?

  private var moderators: [Moderator] = []
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false

  let service = Service()
  let router: ModeratorRouter

  init(router: ModeratorRouter, delegate: ModeratorsViewModelDelegate) {
    self.router = router
    self.delegate = delegate
  }

  var totalCount: Int {
    return total
  }

  var currentCount: Int {
    return moderators.count
  }

  func moderator(at index: Int) -> Moderator {
    return moderators[index]
  }

  func fetchModerators() {
    // 1
    guard !isFetchInProgress else {
      return
    }

    // 2
    isFetchInProgress = true

    service.fetchModerators(with: router, page: currentPage) { result in
      switch result {
      // 3
      case .failure(let error):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.delegate?.onFetchFailed(with: error.reason)
        }
      // 4
      case .success(let response):
        DispatchQueue.main.async {
          // 1
          self.currentPage += 1
          self.isFetchInProgress = false
          // 2
          self.total = response.total
          self.moderators.append(contentsOf: response.moderators)

          // 3
          if response.page > 1 {
            let indexPathsToReload = self.calculateIndexPathsToReload(from: response.moderators)
            self.delegate?.onFetchCompleted(with: indexPathsToReload)
          } else {
            self.delegate?.onFetchCompleted(with: .none)
          }
        }
      }
    }
  }

  private func calculateIndexPathsToReload(from newModerators: [Moderator]) -> [IndexPath] {
    let startIndex = moderators.count - newModerators.count
    let endIndex = startIndex + newModerators.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }
}
