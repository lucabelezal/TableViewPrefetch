//
//  PrefetchViewController.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class PrefetchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var news: [News?] = [News?](repeating: nil, count: 100)
    var dataTasks: [URLSessionDataTask] = []

    let newsIDs = [
        17550600, 17549050, 17550761, 17550837, 17549099, 17548768, 17550808, 17550315, 17551012, 17546915,
        17546491, 17534858, 17544666, 17550754, 17540464, 17540205, 17544687, 17548807, 17542051, 17550532,
        17540321, 17548270, 17549927, 17550199, 17550823, 17548623, 17539726, 17547817, 17548731, 17539765,
        17548676, 17549325, 17539465, 17548285, 17546207, 17550987, 17549797, 17548198, 17548764, 17546876,
        17541045, 17549293, 17544250, 17546731, 17546835, 17550698, 17541600, 17546875, 17540401, 17543323,
        17539548, 17544689, 17550420, 17546979, 17540200, 17544281, 17538390, 17534817, 17543357, 17548103,
        17544300, 17545529, 17545518, 17539969, 17544161, 17536441, 17540383, 17549934, 17547562, 17539361,
        17538322, 17540313, 17535995, 17542949, 17546409, 17537512, 17546006, 17542803, 17540712, 17546832,
        17532682, 17540263, 17536291, 17534950, 17522362, 17539286, 17538697, 17541065, 17538453, 17542864,
        17542556, 17539595, 17538770, 17537250, 17547092, 17541092, 17535909, 17534923, 17543925, 17538261
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        tableView.register(UINib(nibName: CellReuse.loading.name, bundle: nil), forCellReuseIdentifier: CellReuse.loading.identifier)
        tableView.register(UINib(nibName: CellReuse.news.name, bundle: nil), forCellReuseIdentifier: CellReuse.news.identifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }

    func fetchNews(of index: Int) {

    }

    func cancelFetchNews(of index: Int) {

    }

}

extension PrefetchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuse.news.identifier, for: indexPath) as! NewsTableViewCell
        return cell
    }

}

extension PrefetchViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

    }

}
