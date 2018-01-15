//
//  Light.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/3.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class Light: NSObject {
    
    @objc var field2: String = "0"

    @objc var entry_id: Int = 0
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}

