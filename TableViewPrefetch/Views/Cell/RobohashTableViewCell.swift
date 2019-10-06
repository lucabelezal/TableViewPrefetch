//
//  RobohashTableViewCell.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

internal class RobohashTableViewCell: UITableViewCell {

    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    internal func updateAppearanceFor(_ image: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            self.displayImage(image)
        }
    }
    
    private func displayImage(_ image: UIImage?) {
        if let _image = image {
            thumbImageView.image = _image
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
            thumbImageView.image = .none
        }
    }
}
