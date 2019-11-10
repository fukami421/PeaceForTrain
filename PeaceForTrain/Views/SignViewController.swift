//
//  SignViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class SignViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    let signUpVC = SignUpViewController.init(nibName: nil, bundle: nil)
    let loginVC = LoginViewController.init(nibName: nil, bundle: nil)

   
    @IBOutlet weak var segmentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登録"
        self.segmentView.addSubview(signUpVC.view)
        self.segmentView.addSubview(loginVC.view)
        self.loginVC.view.isHidden = true
    }
    
    @IBAction func segmentButton(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            self.title = "登録"
            self.addFirstView()
        case 1:
            self.title = "ログイン"
            self.addSecondView()
        default:
            print("error")
        }
    }
    
    func addFirstView() {
        loginVC.view.isHidden = true
        signUpVC.view.isHidden = false
    }
    
    func addSecondView() {
        signUpVC.view.isHidden = true
        loginVC.view.isHidden = false
    }
}
