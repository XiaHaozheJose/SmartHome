//
//  NavigationBarButton.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/13.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(title: String,target: Any, action: Selector) {
        self.init()
        self.setTitle(title, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setTitleColor(.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.sizeToFit()
    }
}


