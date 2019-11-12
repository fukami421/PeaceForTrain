//
//  ConnectingViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/12.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class TryConnectViewController: UIViewController {
    var isGive:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isGive
        {
            self.title = "席を譲ってあげる"
        }else
        {
            self.title = "席を譲って欲しい"
        }
    }
}
