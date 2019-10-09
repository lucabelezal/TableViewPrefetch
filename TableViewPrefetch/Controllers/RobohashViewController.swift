//
//  ImageViewController.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

internal class RobohashViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var service = RobohashService()
    private lazy var operationQueue = OperationQueue()
    private lazy var operations = [IndexPath: DataLoadOperation]()
    private lazy var cellIdentifier =  "imageCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
}

// MARK: - TableView Delegate

extension RobohashViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell = cell as? RobohashTableViewCell else {
            return
        }

        let updateCellClosure: (UIImage?) -> Void = { [weak self] (image) in
            cell.configureCell(with: image)
            self?.operations.removeValue(forKey: indexPath)
        }

        if let operation = operations[indexPath] {
            if let image = operation.image {
                cell.configureCell(with: image)
                operations.removeValue(forKey: indexPath)
            } else {
                operation.completeHandler = updateCellClosure
            }
        } else {
            if let operation = service.loadImage(at: indexPath.row) {
                operation.completeHandler = updateCellClosure
                operationQueue.addOperation(operation)
                operations[indexPath] = operation
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operation = operations[indexPath] {
            operation.cancel()
            operations.removeValue(forKey: indexPath)
        }
    }
}

// MARK: - TableView Datasource

extension RobohashViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.numberOfImage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        guard let cell = reusableCell as? RobohashTableViewCell else {
            fatalError("Sorry, could not load cell")
        }
        cell.selectionStyle = .none
        cell.configureCell(with: .none)
        return cell
    }
}

// MARK: - TableView Prefetching DataSource

extension RobohashViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            if operations[indexPath] != nil {
                return
            }

            if let operation = service.loadImage(at: indexPath.row) {
                operationQueue.addOperation(operation)
                operations[indexPath] = operation
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            if let operation = operations[indexPath] {
                operation.cancel()
                operations.removeValue(forKey: indexPath)
            }
        }
    }
}
