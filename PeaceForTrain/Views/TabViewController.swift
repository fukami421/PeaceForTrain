//
//  TabViewController.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/11.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let exchangeHomeVC = UINavigationController(rootViewController: ExchangeHomeViewController.init(nibName: nil, bundle: nil))
        // タブのFooter部分を設定
        exchangeHomeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)

        let myPageVC = UINavigationController(rootViewController: MyPageViewController.init(nibName: nil, bundle: nil))
        // タブのFooter部分を設定
        myPageVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        self.viewControllers = [exchangeHomeVC, myPageVC]
    }
}
