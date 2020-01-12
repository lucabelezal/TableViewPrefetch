//
//  ModeratorsListView.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

protocol ModeratorsListViewDelegate: class {
    func fetchNextPageOfModerators()
}

class ModeratorsListView: UIView {

    typealias Cell = TableViewCell<ModeratorCellView, ModeratorCellViewModelProtocol>

    weak var delegate: ModeratorsListViewDelegate?
    
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    let tableView: UITableView = UITableView()

    var viewModel: ModeratorsListViewModelProtocol {
        didSet {
            update()
        }
    }

    override init(frame: CGRect) {
        viewModel = ModeratorsListViewModel()
        super.init(frame: frame)
        setupView()
        
        indicatorView.color = .black
        indicatorView.startAnimating()
        tableView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func update() {
        guard let newIndexPathsToReload = viewModel.indexPathsToReload else {
          indicatorView.stopAnimating()
          tableView.isHidden = false
          tableView.reloadData()
          return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
}

extension ModeratorsListView: ViewCodable {

    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        tableView.register(cellType: Cell.self)
    }

    func hierarchy() {
        addView(indicatorView, tableView)
    }

    func constraints() {

        indicatorView.layout.makeConstraints { make in
            make.centerX.equalTo(layout.centerX)
            make.centerY.equalTo(layout.centerY)
            make.height.equalTo(constant: 60)
            make.width.equalTo(constant: 60)
        }
        
        tableView.layout.makeConstraints { make in
            make.top.equalTo(self.layout.safeArea.top)
            make.bottom.equalTo(self.layout.safeArea.bottom)
            make.left.equalTo(self.layout.left)
            make.right.equalTo(self.layout.right)
        }
    }

    func styles() {
        backgroundColor = .lightGray
        tableView.backgroundColor = .clear
    }
    
}

extension ModeratorsListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        if isLoadingCell(for: indexPath) {
            cell.viewModel = ModeratorCellViewModel(with: .none)
        } else {
            cell.viewModel = viewModel.moderator(indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ModeratorsListView: UITableViewDataSourcePrefetching {
    
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
        delegate?.fetchNextPageOfModerators()
    }
  }
    
}

private extension ModeratorsListView {
    
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
    
}
