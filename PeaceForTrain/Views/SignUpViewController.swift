
//
//  SignUpViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    let udf = UserDefaults.standard
    private let disposeBag = DisposeBag()
    let signUpViewModel = SignUpViewModel()
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var mailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let tabVC = TabViewController.init(nibName: nil, bundle: nil)
    var gender: String = "男性"
    var old: String = "20~29歳"

    // たくさん卒業してしまった...
    let dataList = [
        "0~9歳","10~19歳","20~29歳","30~39歳",
        "40~49歳","50~59歳","60~69歳","70~79歳",
        "80~89歳","90~99歳","100歳以上"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SignUp"
        self.tabVC.modalPresentationStyle = .fullScreen
        self.bind()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.selectRow(2, inComponent: 0, animated: true)// 初期値を20代に設定
        self.UISetUp()
    }

    func UISetUp()
    {
        self.activityIndicator.isHidden = true
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        self.activityIndicator.transform = transfrom
    }

    func bind()
    {
        self.mailTxtField.rx.text.orEmpty
            .bind(to: self.signUpViewModel.name)
            .disposed(by: self.disposeBag)
        
        self.passTxtField.rx.text.orEmpty
            .bind(to: self.signUpViewModel.password)
            .disposed(by: self.disposeBag)
        
        self.segment.rx.selectedSegmentIndex.asObservable()
            .subscribe({_ in
            switch self.segment.selectedSegmentIndex
            {
            case 0:
                self.signUpViewModel.gender.accept("男性")
                self.gender = "男性"
            case 1:
                self.signUpViewModel.gender.accept("女性")
                self.gender = "女性"
            default:
                self.signUpViewModel.gender.accept("男性")
            }
            print(self.signUpViewModel.gender.value)
            })
            .disposed(by: disposeBag)
        
//        self.pickerView.rx.modelSelected(Int.self)
//            .subscribe { (event) in
//                switch event {
//                case .next(let selected):
//                    self.signUpViewModel.old.accept(self.dataList[selected.row])
//                    print("You selected #\(selected.row)")
//                default:
//                    break
//                }
//            }
//            .disposed(by: disposeBag)
        
        self.signUpBtn.rx.tap
        .subscribe { [unowned self] _ in
            if self.canSignIn()
            {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                let canLogin = self.signUpViewModel.api()
                if canLogin == true
                {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.setUserDefault(mail: self.mailTxtField.text!, gender: self.gender, old: self.old)
                    self.present(self.tabVC, animated: true, completion: nil)
                }else
                {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    let alertController = Alert.showAlert(title: "エラー", message: "登録に失敗しました")
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.present(alertController, animated: true)
                }
            }else
            {
                let alertController = Alert.showAlert(title: "エラー", message: "必要項目を入力してください")
                self.present(alertController, animated: true)
            }
        }
        .disposed(by: self.disposeBag)
    }
    
    func canSignIn() -> Bool
    {
        if self.signUpViewModel.name.value != "" && self.signUpViewModel.password.value != ""
        {
            return true
        }else
        {
            return false
        }
    }
    
    func setUserDefault(mail:String, gender: String, old: String)
    {
        udf.set(mail, forKey: "mail")
        udf.set(gender, forKey: "gender")
        udf.set(old, forKey: "old")
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
        self.signUpViewModel.old.accept(self.dataList[row])
        self.old = self.dataList[row]
     }
}
