//
//  ImageCacheAssistant.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation
import UIKit

final class ImageCacheAssistant {
    private var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    func getImage(for key: String?) -> UIImage? {
        if let currentKey = key, self.cache.object(forKey: currentKey as AnyObject) != nil {
            return self.cache.object(forKey: key as AnyObject) as? UIImage
        }
        return nil
    }
    
    func setImage(_ image: UIImage, for key: String) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    func clearCache() {
        self.cache.removeAllObjects()
    }
}
