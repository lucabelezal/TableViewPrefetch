//
//  ModeratorsListViewController.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class ModeratorsListViewController: UIViewController {
    
    private enum CellIdentifiers {
      static let list = "List"
    }
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    var site: String!
    
    private var viewModel: ModeratorsViewModel!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
      indicatorView.color = ColorPalette.RWGreen
      indicatorView.startAnimating()
      
      tableView.isHidden = true
      tableView.separatorColor = ColorPalette.RWGreen
      tableView.dataSource = self
      tableView.prefetchDataSource = self
      
      let router = ModeratorRouter.from(site: site)
      viewModel = ModeratorsViewModel(router: router, delegate: self)
      
      viewModel.fetchModerators()
    }
}

extension ModeratorsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.totalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! ModeratorTableViewCell
    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: viewModel.moderator(at: indexPath.row))
    }
    return cell
  }
}

extension ModeratorsListViewController: ModeratorsViewModelDelegate, AlertDisplayer {
    
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      indicatorView.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      return
    }

    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }
  
  func onFetchFailed(with reason: String) {
    indicatorView.stopAnimating()
    
    let title = "Warning".localizedString
    let action = UIAlertAction(title: "OK".localizedString, style: .default)
    displayAlert(with: title , message: reason, actions: [action])
  }
}

private extension ModeratorsListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

extension ModeratorsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.fetchModerators()
    }
  }
}
