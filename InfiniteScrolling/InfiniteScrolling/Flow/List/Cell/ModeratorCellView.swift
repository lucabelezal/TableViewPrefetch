//
//  ModeratorCellView.swift
//  InfiniteScrolling
//
//  Created by Lucas Nascimento on 11/01/20.
//  Copyright © 2020 Lucas Nascimento. All rights reserved.
//

import UIKit

class ModeratorCellView: UIView, ViewModelOwner {
    
    var isSelected: Bool = false
    
    var viewModel: ModeratorCellViewModelProtocol? {
        didSet {
            update()
        }
    }
    
    let reputationContainerView: UIView = UIView()
    let displayNameLabel: UILabel = UILabel()
    let reputationLabel: UILabel = UILabel()
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if let displayName = viewModel?.displayName, let reputation = viewModel?.reputation {
          displayNameLabel.text = displayName
          reputationLabel.text = reputation
          displayNameLabel.alpha = 1
          reputationContainerView.alpha = 1
          indicatorView.stopAnimating()
        } else {
          displayNameLabel.alpha = 0
          reputationContainerView.alpha = 0
          indicatorView.startAnimating()
        }
    }
}

extension ModeratorCellView: ViewCodable {
    
    func configure() {}
    
    func hierarchy() {
        reputationContainerView.addView(reputationLabel)
        addView(indicatorView, displayNameLabel, reputationContainerView)
    }
    
    func constraints() {
        indicatorView.layout.makeConstraints { make in
            make.centerX.equalTo(layout.centerX)
            make.centerY.equalTo(layout.centerY)
            make.width.equalTo(constant: 30)
            make.height.equalTo(constant: 30)
        }
        
        displayNameLabel.layout.makeConstraints { make in
            make.top.equalTo(layout.top, constant: 16)
            make.bottom.equalTo(layout.bottom, constant: -16)
            make.left.equalTo(layout.left, constant: 16)
            make.right.greaterThanOrEqualTo(indicatorView.layout.left, constant: -16)
        }
                
        reputationContainerView.layout.makeConstraints { make in
            make.top.equalTo(layout.top, constant: 16)
            make.bottom.equalTo(layout.bottom, constant: -16)
            make.left.greaterThanOrEqualTo(indicatorView.layout.right, constant: 16)
            make.right.equalTo(layout.right, constant: -16)
        }
        
        reputationLabel.layout.makeConstraints { make in
            make.top.equalTo(reputationContainerView.layout.top, constant: 8)
            make.bottom.equalTo(reputationContainerView.layout.bottom, constant: -8)
            make.left.equalTo(reputationContainerView.layout.left, constant: 8)
            make.right.equalTo(reputationContainerView.layout.right, constant: -8)
        }
    }
    
    func styles() {
        reputationContainerView.backgroundColor = .lightGray
        reputationContainerView.layer.cornerRadius = 6
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .black
    }
}
