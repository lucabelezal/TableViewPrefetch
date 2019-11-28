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

    private lazy var operationQueue = OperationQueue()
    private lazy var images = [IndexPath: DataLoadOperation]()
    private lazy var service = RobohashService()
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

    private func loadData(at indexPath: IndexPath, for cell: RobohashTableViewCell) {

        let updateCell: (UIImage?) -> Void = { [weak self] (image) in
            self?.update(cell, with: image, at: indexPath)
        }

        loadImage(at: indexPath, isUpdated: true) { data in
            data?.updateCell = updateCell
        }
    }

    private func loadImage(at indexPath: IndexPath, isUpdated: Bool = false, updateCell: ((DataLoadOperation?) -> Void)?) {
        if let data = service.loadImage(at: indexPath.row) {
            operationQueue.addOperation(data)
            images[indexPath] = data

            if isUpdated {
                updateCell?(data)
            }
        }
    }

    private func cancelLoadImage(at indexPath: IndexPath) {
        if let data = images[indexPath] {
            data.cancel()
            images.removeValue(forKey: indexPath)
        }
    }

    private func update(_ cell: RobohashTableViewCell, with image: UIImage?, at indexPath: IndexPath) {
        cell.configureCell(with: image)
        images.removeValue(forKey: indexPath)
    }
}

// MARK: - TableView Delegate

extension RobohashViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell = cell as? RobohashTableViewCell else {
            return
        }

        loadData(at: indexPath, for: cell)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoadImage(at: indexPath)
    }
}

// MARK: - TableView Datasource

extension RobohashViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.numberOfImage
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        guard let cell = reusableCell as? RobohashTableViewCell else { fatalError("Sorry, could not load cell") }
        cell.selectionStyle = .none
        cell.configureCell(with: .none)
        return cell
    }
}

// MARK: - TableView Prefetching DataSource

extension RobohashViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths where images[indexPath] != nil {
            loadImage(at: indexPath, updateCell: nil)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
            cancelLoadImage(at: indexPath)
        }
    }
}
