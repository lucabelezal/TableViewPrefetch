//
//  PostTableViewCell.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    func configureCell(with post: Post) {
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
    }
}
