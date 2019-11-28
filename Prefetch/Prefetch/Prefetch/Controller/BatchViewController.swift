//
//  BatchViewController.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class BatchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let baseURL = "https://api.coinmarketcap.com/v2/ticker/?"
    let itemsPerBatch = 15

    var coins: [Coin] = []
    var currentRow: Int = 1

    var url: URL {
        return URL(string: "\(baseURL)start=\(currentRow)&limit=\(itemsPerBatch)")!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        tableView.register(UINib(nibName: CellReuse.loading.name, bundle: nil), forCellReuseIdentifier: CellReuse.loading.identifier)
        tableView.register(UINib(nibName: CellReuse.coin.name, bundle: nil), forCellReuseIdentifier: CellReuse.coin.identifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
    }

    func loadData() {

        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, _, _ in

            guard let data = data else {
                print("No data")
                return
            }

            guard let coinList = try? JSONDecoder().decode(CoinList.self, from: data) else {
                print("Error: Couldn't decode data into coin list")
                return
            }

            let coinsSorted = coinList.data.sorted { $0.value.rank < $1.value.rank }
            for coin in coinsSorted {
                self.coins.append(coin.value)
            }

            self.currentRow += self.itemsPerBatch

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }.resume()
    }

}

extension BatchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == coins.count {
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuse.loading.identifier, for: indexPath) as! LoadingTableViewCell
            cell.activityIndicator.startAnimating()
            loadData()
            return cell
        }

        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuse.coin.identifier, for: indexPath) as! CoinTableViewCell
        let coin = coins[indexPath.row]
        cell.configureCell(with: coin)
        return cell
    }

}
