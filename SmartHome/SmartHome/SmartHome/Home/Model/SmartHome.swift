//
//  SmartHome.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/11.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class SmartHome: NSObject {

    @objc var field1: String = ""
    @objc var field2: String = ""
    @objc var field3: String = ""
    @objc var field4: String = ""
    @objc var field5: String = ""
    @objc var field6: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
