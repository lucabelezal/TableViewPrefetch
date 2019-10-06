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

    internal var image: UIImage?
    internal var loadingCompleteHandler: ((UIImage?) -> Void)?
    private var imageModel: Robohash

    internal init(_ imageModel: Robohash) {
        self.imageModel = imageModel
    }

    override func main() {

        if isCancelled {
            return
        }

        guard let url = imageModel.url else {
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
                self.loadingCompleteHandler?(self.image)
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
