
//
//  SignUpViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    // たくさん卒業してしまった...
    let dataList = [
        "0~9歳","10~19歳","20~29歳","30~39歳",
        "40~49歳","50~59歳","60~69歳","70~79歳",
        "80~89歳","90~99歳","100歳以上"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SignUp"
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.selectRow(2, inComponent: 0, animated: true)// 初期値を20代に設定
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // UIPickerViewの列の数
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     // UIPickerViewの行数、リストの数
     func pickerView(_ pickerView: UIPickerView,
                     numberOfRowsInComponent component: Int) -> Int {
         return dataList.count
     }
     
     // UIPickerViewの最初の表示
     func pickerView(_ pickerView: UIPickerView,
                     titleForRow row: Int,
                     forComponent component: Int) -> String? {
         return dataList[row]
     }
     
     // UIPickerViewのRowが選択された時の挙動
     func pickerView(_ pickerView: UIPickerView,
                     didSelectRow row: Int,
                     inComponent component: Int) {
     }
}
