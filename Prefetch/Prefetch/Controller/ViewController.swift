//
//  ViewController.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }

    func setupView() {
        tableView.register(UINib(nibName: CellReuse.post.name, bundle: nil), forCellReuseIdentifier: CellReuse.post.identifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self

        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }

    func loadData() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, _, _ in

            guard let data = data else {
                print("No data")
                return
            }

            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                print("Error: Couldn't decode data into post model")
                return
            }

            self.posts = posts

            DispatchQueue.main.async {
                self.loadingActivityIndicator.stopAnimating()
                self.loadingActivityIndicator.isHidden = true
                self.tableView.reloadData()
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuse.post.identifier, for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configureCell(with: post)
        return cell
    }
}
