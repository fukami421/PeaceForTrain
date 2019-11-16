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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isGive:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.UISetUp()
    }
    
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

}
