//
//  HTTPURLResponse.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}
