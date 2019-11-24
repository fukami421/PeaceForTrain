//
//  Login.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/15.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import Foundation

struct Login: Codable {
    var count: Int
    var gender: String
    var old: String
    var id: Int

    enum CodingKeys: String, CodingKey {
        case count
        case gender
        case old
        case id
    }
  
    init()
    {
        self.count = 0
        self.gender = ""
        self.old = ""
        self.id = 0
    }
}
