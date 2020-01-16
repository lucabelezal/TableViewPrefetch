//
//  ModeratorsListView.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

protocol ModeratorsListViewDelegate: class {
    func fetchNextPage()
}

class ModeratorsListView: UIView {
    
    typealias Cell = TableViewCell<ModeratorCellView, ModeratorCellViewModelProtocol>
    
    weak var delegate: ModeratorsListViewDelegate?
    
    var viewModel: ModeratorsListViewModelProtocol {
        didSet {
            update()
        }
    }
    
    private let indicatorView: UIActivityIndicatorView
    private let tableView: UITableView
    
    override init(frame: CGRect) {
        indicatorView = UIActivityIndicatorView(style: .large)
        tableView = UITableView()
        viewModel = ModeratorsListViewModel()
        super.init(frame: frame)
        setupView()
        startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        guard let newIndexPathsToReload = viewModel.indexPathsToReload else {
            stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }

        UIView.transition(with: tableView, duration: 0, options: [], animations: {
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: indexPathsToReload, with: .none)
            self.tableView.endUpdates()
        }, completion: nil)
    }
    
    func stopAnimating() {
        indicatorView.stopAnimating()
    }
    
    func startAnimating() {
        indicatorView.startAnimating()
    }
}

extension ModeratorsListView: ViewCodable {
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        tableView.isHidden = true
        tableView.register(cellType: Cell.self)
    }
    
    func hierarchy() {
        addView(indicatorView, tableView)
    }
    
    func constraints() {
        
        indicatorView.layout.makeConstraints { make in
            make.centerX.equalTo(layout.centerX)
            make.centerY.equalTo(layout.centerY)
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
        indicatorView.color = .black
    }
}

extension ModeratorsListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        if !isLoadingCell(for: indexPath) {
            cell.viewModel = viewModel.moderator(indexPath.row)
        }
        return cell
    }
}

extension ModeratorsListView: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            delegate?.fetchNextPage()
        }
    }
}

extension ModeratorsListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
