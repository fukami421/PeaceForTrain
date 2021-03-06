//
//  ConnectingViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/12.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TryConnectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var outlineLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var oldLbl: UILabel!
    @IBOutlet weak var stop: UIButton!
    
    var isGive:Bool = false
    let tryConnectViewModel = TryConnectViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.UISetUp()
        self.bind()
        self.stop.isHidden = true
        self.tryConnectViewModel.isGive = self.isGive
        self.tryConnectViewModel.setUpMonitoring()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.viewWillDisappear(animated)
//        do
//        {
//            self.tryConnectViewModel.stopAdvertising()
//            print("stop")
//        }catch
//        {
//            print("error")
//        }
//    }
    
    func UISetUp()
    {
        if self.isGive
        {
            self.title = "席を譲ってあげる"
        }else
        {
            self.title = "席を譲って欲しい"
        }

        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        self.activityIndicator.transform = transfrom
    }
    
    func bind()
    {
        self.tryConnectViewModel.isDisplayActivityIndicator
            .subscribe(onNext: { [unowned self] isDisplayActivityIndicator in
                if isDisplayActivityIndicator //
                {
                    self.activityIndicator.isHidden = false
                    self.outlineLbl.text = "交換相手を探しています"
                }else
                { self.navigationController?.navigationBar.isUserInteractionEnabled = false
                    self.activityIndicator.isHidden = true
                    self.outlineLbl.text = "交換相手が見つかりました"
                }
            })
            .disposed(by: self.disposeBag)
        
        self.stop.rx.tap
            .subscribe(onNext: {
                self.tryConnectViewModel.stopAdvertising()
            })
            .disposed(by: self.disposeBag)
        
        self.tryConnectViewModel.distance
            .bind(to: self.distanceLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        self.tryConnectViewModel.gender
            .bind(to: self.genderLbl.rx.text)
            .disposed(by: self.disposeBag)

        self.tryConnectViewModel.old
            .bind(to: self.oldLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func isHiddenUI(isHiden: Bool)
    {
//        self.distanceLbl.isHidden = true
//        self.
    }
}
