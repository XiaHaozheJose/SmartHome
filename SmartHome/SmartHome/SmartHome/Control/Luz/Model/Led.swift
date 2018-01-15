//
//  Led.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/8.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation

class Led: NSObject {
    
    
    @objc var field6: String = ""
    @objc var entry_id: Int = 0
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
