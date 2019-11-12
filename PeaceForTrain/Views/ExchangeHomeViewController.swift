//
//  ExchangeHomeViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/11.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExchangeHomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var connectingVC: TryConnectViewController!
    
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var giveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.title = "席交換"
    }
    
    func bind()
    {
        self.getBtn.rx.tap
        .subscribe { [unowned self] _ in
            self.connectingVC = TryConnectViewController.init(nibName: nil, bundle: nil)
            self.connectingVC.isGive = false
            self.navigationController?.pushViewController(self.connectingVC, animated: true)
        }
        .disposed(by: self.disposeBag)
        
        self.giveBtn.rx.tap
        .subscribe { [unowned self] _ in
            self.connectingVC = TryConnectViewController.init(nibName: nil, bundle: nil)
            self.connectingVC.isGive = true
            self.navigationController?.pushViewController(self.connectingVC, animated: true)
        }
        .disposed(by: self.disposeBag)
    }
}
