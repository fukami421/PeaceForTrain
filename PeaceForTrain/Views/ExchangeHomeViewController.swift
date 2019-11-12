//
//  ExchangeHomeViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/11.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class ExchangeHomeViewController: UIViewController {
    var connectingVC: TryConnectViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "席交換"
    }
    @IBAction func getBtn(_ sender: Any) {
        self.connectingVC = TryConnectViewController.init(nibName: nil, bundle: nil)
        connectingVC.isGive = false
        self.navigationController?.pushViewController(self.connectingVC, animated: true)
    }
    
    @IBAction func giveBtn(_ sender: Any) {
        self.connectingVC = TryConnectViewController.init(nibName: nil, bundle: nil)
        connectingVC.isGive = true
        self.navigationController?.pushViewController(self.connectingVC, animated: true)
    }
}
