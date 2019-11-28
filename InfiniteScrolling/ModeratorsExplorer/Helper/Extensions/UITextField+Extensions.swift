//
//  UITextField+Extensions.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import UIKit

extension UITextField {

  func setBottomBorder() {
    borderStyle = .none
    layer.backgroundColor = UIColor.white.cgColor

    layer.masksToBounds = false

    layer.shadowColor = ColorPalette.RWGreen.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
  }
}
