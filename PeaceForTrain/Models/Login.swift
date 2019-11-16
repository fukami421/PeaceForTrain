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

    enum CodingKeys: String, CodingKey {
        case count
    }
  
    init()
    {
        self.count = 0
    }
}
