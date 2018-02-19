//
//  TabBarViewController.swift
//  PokeGym
//
//  Created by Cerebro on 06/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
   
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let listView = self.viewControllers![0] as! UINavigationController
        listView.popToRootViewController(animated: false)

        let mapView = self.viewControllers![1] as! UINavigationController
        mapView.popToRootViewController(animated: false)
    }

}
