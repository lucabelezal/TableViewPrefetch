//
//  ModeratorRequest.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

struct ModeratorRouter {

    let parameters: Parameters

    var path: String {
      return "users/moderators"
    }

    private init(parameters: Parameters) {
      self.parameters = parameters
    }
}

extension ModeratorRouter {

    static func from(site: String) -> ModeratorRouter {
       let defaultParameters = ["order": "desc",
                                "sort": "reputation",
                                "filter": "!-*jbN0CeyJHb"]

       let parameters = ["site": "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
       return ModeratorRouter(parameters: parameters)
     }
}
