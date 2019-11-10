//
//  LoginViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/10.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class LoginViewController: UIView {
       override init(frame: CGRect){
           super.init(frame: frame)
           loadNib()
       }
    
       required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
           loadNib()
       }
    
       func loadNib(){
           let view = Bundle.main.loadNibNamed("LoginViewController", owner: self, options: nil)?.first as! UIView
           view.frame = self.bounds
           self.addSubview(view)
       }
}
