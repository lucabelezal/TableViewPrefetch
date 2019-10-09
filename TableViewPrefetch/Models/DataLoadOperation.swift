//
//  DataLoadOperation.swift
//  TableViewPrefetch
//
//  Created by Lucas Nascimento on 05/10/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import Foundation
import UIKit.UIImage

internal class DataLoadOperation: Operation {

    internal var completeHandler: ((UIImage?) -> Void)?
    internal private(set) var image: UIImage?
    private var robohash: Robohash

    internal init(robohash: Robohash) {
        self.robohash = robohash
    }

    override func main() {

        if isCancelled {
            return
        }

        guard let url = robohash.url else {
            return
        }

        downloadImageFrom(url) { (image) in

            DispatchQueue.main.async { [weak self] in

                guard let `self` = self else {
                    return
                }

                if self.isCancelled {
                    return
                }

                self.image = image
                self.completeHandler?(self.image)
            }
        }
    }

    private func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let _image = UIImage(data: data)
                else { return }
            completeHandler(_image)
            }.resume()
    }
}
