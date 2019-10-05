//
//  ImageViewController.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

public class ImageViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cellReuseIdentifier = "imageCell"

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

// MARK: - TableView Delegate

extension ImageViewController: UITableViewDelegate {}

// MARK: - TableView Datasource

extension ImageViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ImageTableViewCell else {
            fatalError("Sorry, could not load cell")
        }
        return cell
    }
}
