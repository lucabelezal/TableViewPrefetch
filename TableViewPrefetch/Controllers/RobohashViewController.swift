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

    private lazy var service: RobohashService = RobohashService()
    private lazy var loadingQueue: OperationQueue = OperationQueue()
    private lazy var loadingOperations: [IndexPath: DataLoadOperation] = [IndexPath: DataLoadOperation]()
    private lazy var cellIdentifier: String =  "imageCell"

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
        
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (UIImage?) -> Void = { [weak self] (image) in
            cell.updateAppearanceFor(image)
            self?.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let image = dataLoader.image {
                cell.updateAppearanceFor(image)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            if let dataLoader = service.loadImage(at: indexPath.row) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
}

// MARK: - TableView Datasource

extension RobohashViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.numberOfImage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RobohashTableViewCell else {
            fatalError("Sorry, could not load cell")
        }
        cell.selectionStyle = .none
        cell.updateAppearanceFor(.none)
        return cell
    }
}

// MARK: - TableView Prefetching DataSource

extension RobohashViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            if loadingOperations[indexPath] != nil {
                return
            }

            if let dataLoader = service.loadImage(at: indexPath.row) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
