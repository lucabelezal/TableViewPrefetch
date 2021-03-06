//
//  CoinTableViewCell.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    func configureCell(with coin: Coin) {
        self.nameLabel.text = coin.name
        self.symbolLabel.text = coin.symbol
        self.rankLabel.text = "# \(coin.rank)"
        self.priceLabel.text = "$ \(String(describing: coin.quotes["USD"]?.price))"
    }
}
