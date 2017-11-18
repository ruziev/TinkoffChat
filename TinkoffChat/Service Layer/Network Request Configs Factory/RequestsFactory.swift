//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/18/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct PixabayRequests {
        static func imageInfosConfig(keywords: [String]) -> RequestConfigMany<PixabayImageInfoModel, PixabayImageInfoParser> {
            return RequestConfigMany(
                request: PixabayImageInfoRequest(apiKey: "7095009-d65414cc94cbb0b1bf16186d2", keywords: keywords),
                parser: PixabayImageInfoParser()
            )
        }
        
        static func imagesConfig(url: URL) -> RequestConfig<PixabayImageModel, PixabayImageParser> {
            return RequestConfig(
                request: PixabayImageRequest(url: url),
                parser: PixabayImageParser()
            )
        }
    }
}
