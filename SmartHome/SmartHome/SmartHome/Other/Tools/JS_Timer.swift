//
//  JS_Timer.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/3.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_Timer: NSObject {
    private var _timer:Timer!
    /**
     运行中的状态值
     **/
    private var _running = false
    public var running:Bool {
        get{
            return _running
        }
    }
    /**
     暂停或停止的状态值
     **/
    private var _isPause = true
    public var isPause:Bool{
        get{
            return _isPause
        }
    }
    /**
     执行的间隔时间(默认3秒)
     重新设置这个值之后需要重新启动timer
     **/
    public var intervalTime:Double = 3 {
        willSet{
            if intervalTime != newValue && _timer != nil {
                if _running {
                    close()
                }
                _timer = Timer(timeInterval: TimeInterval(newValue), repeats: repeats, block: run)
            }
        }
    }
    /**
     一直重复执行(true)or执行一次(false,默认)
     重新设置这个值之后需要重新启动timer
     **/
    public var repeats:Bool = false {
        willSet{
            if repeats != newValue && _timer != nil {
                if _running {
                    close()
                }
                _timer = Timer(timeInterval: TimeInterval(intervalTime), repeats: newValue, block: run)
            }
        }
    }
    /**
     需要重复执行的功能
     **/
    public var repeatRun:(()->Void)?
    
    init(interval:Double, repeats:Bool, repeatRun: @escaping (()->Void)) {
        self.intervalTime = interval
        self.repeats = repeats
        self.repeatRun = repeatRun
    }
    /**
     启动timer
     **/
    public func start() {
        if !_running {
            _timer = Timer(timeInterval: TimeInterval(intervalTime), repeats: repeats, block: run)
            RunLoop.current.add(_timer, forMode: .commonModes)
            _running = true
            _isPause = false
        }
    }
    /**
     关闭timer
     **/
    public func close() {
        if _running {
            _isPause = true
            _running = false
            _timer.invalidate()
            _timer = nil
        }
    }
    /**
     停止或暂停timer
     **/
    public func stop() {
        if _running && !_isPause {
            _timer.fireDate = Date.distantFuture
            _isPause = true
        }
    }
    /**
     从停止或暂停中恢复timer
     **/
    public func resume() {
        if _running && _isPause {
            _timer.fireDate = Date(timeIntervalSinceNow: intervalTime)
            _isPause = false
        }
    }
    private func run(timer:Timer) {
        repeatRun?()
    }
}

