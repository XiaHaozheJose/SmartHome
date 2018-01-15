//
//  MainNavigationController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/13.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func loadView() {
        super.loadView()
        let bar = UINavigationBar.appearance()
        bar.barTintColor = normalBgColor
        bar.tintColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
