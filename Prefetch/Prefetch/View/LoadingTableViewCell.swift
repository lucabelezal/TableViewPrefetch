//
//  LoadingTableViewCell.swift
//  Prefetch
//
//  Created by Lucas Nascimento on 15/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var loadingView: UIActivityIndicatorView {
        return activityIndicator
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
