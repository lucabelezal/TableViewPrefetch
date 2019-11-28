//
//  Double+Extensions.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

extension Double {
    
  static let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()
  
  var formatted: String {
    return Double.formatter.string(for: self) ?? String(self)
  }
}
