//
//  LoginViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let udf = UserDefaults.standard
    private let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    @IBOutlet weak var mailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let tabVC = TabViewController.init(nibName: nil, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ログイン"
        self.tabVC.modalPresentationStyle = .fullScreen
        self.bind()
        self.UISetUp()
    }
    
    func UISetUp()
    {
        // ActivityIndicatorに関して
        self.activityIndicator.isHidden = true
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        self.activityIndicator.transform = transfrom

        self.passTxtField.isSecureTextEntry = true
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        self.view.addGestureRecognizer(singleTapGesture)
    }
    
    func bind()
    {
        self.mailTxtField.rx.text.orEmpty
            .bind(to: self.loginViewModel.mail)
            .disposed(by: self.disposeBag)
        
        self.passTxtField.rx.text.orEmpty
            .bind(to: self.loginViewModel.password)
            .disposed(by: self.disposeBag)

        self.loginBtn.rx.tap
        .subscribe { [unowned self] _ in
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            let canLogin = self.loginViewModel.api()
            if canLogin == 1
            {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.udf.set(self.mailTxtField.text, forKey: "mail")
                self.present(self.tabVC, animated: true, completion: nil)
            }else if canLogin == 0
            {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                let alertController = Alert.showAlert(title: "エラー", message: "ログインに失敗しました")
                self.present(alertController, animated: true)
            }
        }
        .disposed(by: self.disposeBag)
    }

    @objc func singleTap(_ gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
        return
    }
}
