//
//  ProfileManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit.UIImage

class ProfileManager: NSObject, NSCoding {
    
    static var shared = ProfileManager()
    
    struct keys {
        static let image = "image"
        static let name = "name"
        static let info = "info"
    }
    
    var image: UIImage?
    var name: String?
    var info: String?
    
    override init() {
        
    }
    
    func update(name: String? = nil, info: String? = nil, image: UIImage? = nil) -> Bool {
        var hasChanged = false
        if let newName = name, newName != self.name {
            self.name = newName
            hasChanged = true
        }
        if let newInfo = info, newInfo != self.info {
            self.info = newInfo
            hasChanged = true
        }
        if let newImage = image, newImage != self.image {
            self.image = newImage
            hasChanged = true
        }
        return hasChanged
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: keys.name)
        aCoder.encode(info, forKey: keys.info)
        aCoder.encode(image, forKey: keys.image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        name = aDecoder.decodeObject(forKey: keys.name) as? String
        info = aDecoder.decodeObject(forKey: keys.info) as? String
        image = aDecoder.decodeObject(forKey: keys.image) as? UIImage
    }
}
