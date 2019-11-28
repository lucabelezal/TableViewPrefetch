//
//  RobohashTableViewCell.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

internal class RobohashTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var thumbImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageShadow()
    }

    internal func configureCell(with image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.displayImage(image)
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

    private func configureImageShadow() {
        containerView.layer.cornerRadius = 134.5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        containerView.layer.shadowRadius = 25.0
        containerView.layer.shadowOpacity = 0.9
        containerView.layer.shadowPath = UIBezierPath(roundedRect: thumbImageView.bounds,
                                                      cornerRadius: 134.5).cgPath

        thumbImageView.layer.cornerRadius = 134.5
        thumbImageView.clipsToBounds = true
    }
}
