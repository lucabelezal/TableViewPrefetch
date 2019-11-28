//
//  URLRequest.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

extension URLRequest {

    func encode(with parameters: Parameters?) -> URLRequest {

        guard let parameters = parameters else {
            return self
        }

        var encodedURLRequest = self

        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {

            let queryItems = parameters.map { name, value in
                URLQueryItem(name: name, value: value)
            }

            var newUrlComponents = urlComponents
            newUrlComponents.queryItems = queryItems

            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
        } else {
            return self
        }
    }
}
