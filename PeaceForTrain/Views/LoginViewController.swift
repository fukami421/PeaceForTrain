//
//  LoginViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var mailTxtField: UITextField!
    let tabVC = TabViewController.init(nibName: nil, bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ログイン"
        self.tabVC.modalPresentationStyle = .fullScreen
    }
    @IBAction func loginBtn(_ sender: Any) {
        self.present(self.tabVC, animated: true, completion: nil)
    }
}
