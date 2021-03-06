//
//  PixabayImage.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/19/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

struct PixabayImageModel {
    var image: UIImage
}

class PixabayImageRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(url: URL) {
        urlRequest = URLRequest(url: url)
    }
}

class PixabayImageParser: IParser {
    typealias ModelType = PixabayImageModel
    
    func parse(from data: Data) -> PixabayImageModel? {
        guard let image = UIImage(data: data) else {
            print("Could not convert data to image")
            return nil
        }
        return PixabayImageModel(image: image)
    }
}
