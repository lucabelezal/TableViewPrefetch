//
//  NewsTableViewCell.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    func configureCell(with news: News) {
        self.titleLabel.text = news.title
        self.urlLabel.text = news.url
        self.authorLabel.text = news.by
    }

    func truncateCell() {
        self.titleLabel.text = "Loading..."
        self.urlLabel.text = "Loading..."
        self.authorLabel.text = "Loading..."
    }

}
