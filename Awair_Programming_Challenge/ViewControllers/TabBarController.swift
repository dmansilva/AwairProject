//
//  TabBarController.swift
//  Awair_Programming_Challenge
//
//  Created by Daniel Silva on 3/13/19.
//  Copyright © 2019 D Silvv Apps. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = ScoreVC()
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let secondVC = TipsVC()
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let thirdVC = TrendVC()
        thirdVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 2)
        
        let fourthVC = AwairPlusVC()
        fourthVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
        
        let fifthVC = NotificationsTVC()
        fifthVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 4)
        
        let tabBarList = [firstVC, secondVC, thirdVC, fourthVC, fifthVC]

        viewControllers = tabBarList.map {
            (UINavigationController(rootViewController: $0)) }

    }

}
