//
//  ImageDownloader.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import UIKit

struct ImageDownloader {
    static func downloadedFrom(url: URL, completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    return
            }
            completion(image)
            }.resume()
    }
    
    static func downloadedFrom(link: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: link) else {
            return
        }
        self.downloadedFrom(url: url, completion: completion)
    }
}
