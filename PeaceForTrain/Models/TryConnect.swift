//
//  TryConnect.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/24.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import Foundation

struct TryConnect: Codable {
    var old: String
    var gender: String

    enum CodingKeys: String, CodingKey {
        case old
        case gender
    }
  
    init()
    {
        self.old = ""
        self.gender = ""
    }
}
