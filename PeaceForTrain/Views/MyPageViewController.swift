//
//  MyPageViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/11.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
    let udf = UserDefaults.standard
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var oldLbl: UILabel!
    
    let myPageViewModel = MyPageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MyPage"
        self.UISetUp()
        // todo: ログアウトの定義
    }
    
    func UISetUp()
    {
        self.mailLbl.text = self.udf.string(forKey: "mail")
        self.genderLbl.text = self.udf.string(forKey: "gender")
        self.oldLbl.text = self.udf.string(forKey: "old")
    }
}
