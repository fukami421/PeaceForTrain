//
//  SignUp.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/16.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import Foundation

struct SignUp: Codable {
    var result: Int

    enum CodingKeys: String, CodingKey {
        case result
    }
  
    init()
    {
        self.result = 2
    }
}
