//
//  Temperatura.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class Temperatura: NSObject {

    
    @objc var field1: String = ""
    @objc var entry_id: Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
