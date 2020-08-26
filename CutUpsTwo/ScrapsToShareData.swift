//
//  ScrapsToShareData.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 8/25/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import Foundation

class ScrapsToShareData: Codable {
    var array: [String] = []
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
