//
//  Alert.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/16.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import Foundation
import UIKit

class  Alert: UIViewController{
    static func showAlert(title:String, message:String) -> UIAlertController{
        let alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        return alertController
    }
}
