//
//  Service.swift
//  ModeratorsExplorer
//
//  Created by Lucas Nascimento on 09/11/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation

final class Service {

    private lazy var baseURL: URL = {
      return URL(string: "http://api.stackexchange.com/2.2/")!
    }()

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
      self.session = session
    }

    func fetchModerators(with router: ModeratorRouter,
                         page: Int,
                         completion: @escaping (Result<ModeratorData, DataResponseError>) -> Void) {

        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(router.path))
        let parameters = ["page": "\(page)"].merging(router.parameters, uniquingKeysWith: +)
        let encodedURLRequest  = urlRequest.encode(with: parameters)

        session.dataTask(with: encodedURLRequest) { (data, response, _) in

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode, let data = data else {

                    return completion(Result.failure(DataResponseError.network))
            }

            guard let decodedResponse = try? JSONDecoder().decode(ModeratorData.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }

            completion(Result.success(decodedResponse))

        }.resume()
    }

}
