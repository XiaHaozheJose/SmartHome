//
//  VoiceRecordView.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit



class VoiceRecordView: UIView {
    fileprivate var recordingView: VoiceToastView.VoiceRecordingView?
    fileprivate var releaseToCancelView: VoiceToastView.VoiceReleaseToCancel?
    fileprivate var countingView: VoiceToastView.VoiceRecordCountingView?
    fileprivate var currentState: VoiceRecordState = .Normal
    
    convenience init() {
        self.init()
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUp(){
    
        if recordingView == nil{
            recordingView = VoiceToastView.VoiceRecordingView.init(frame: self.bounds)
            self.addSubview(recordingView!)
            recordingView?.isHidden = true
        }
        
        if releaseToCancelView == nil{
            releaseToCancelView = VoiceToastView.VoiceReleaseToCancel.init(frame: self.bounds)
            self.addSubview(releaseToCancelView!)
            releaseToCancelView?.isHidden = true
        }
        
        if countingView == nil{
            countingView = VoiceToastView.VoiceRecordCountingView.init(frame: self.bounds)
            self.addSubview(countingView!)
            countingView?.isHidden = true
        }
        
        self.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recordingView?.frame = self.bounds
        releaseToCancelView?.frame = self.bounds
        countingView?.frame = self.bounds
    }
    
    
    func updatePower(power: Float){
        print(currentState)
        if currentState != .Recording {
            return
        }
        recordingView?.updateWithPower(power: power)
    }
    
    func updateWithRemainTime(remainTIme: Float){
        if currentState != .RecordCounting || releaseToCancelView?.isHidden == false{
            return
        }
        countingView?.updateWithRemainTime(remainTIme: remainTIme)
    }
    
    func updateUIWithRecordState(state: VoiceRecordState){
        currentState = state
        switch state {
        case .Normal:
            recordingView?.isHidden = true
            releaseToCancelView?.isHidden = true
            countingView?.isHidden = true
        case .Recording:
        recordingView?.isHidden = false
        releaseToCancelView?.isHidden = true
        countingView?.isHidden = true
        case .ReleaseToCancel:
            recordingView?.isHidden = true
            releaseToCancelView?.isHidden = false
            countingView?.isHidden = true
        case .RecordCounting:
            recordingView?.isHidden = true
            releaseToCancelView?.isHidden = true
            countingView?.isHidden = false
        default:
            recordingView?.isHidden = true
            releaseToCancelView?.isHidden = true
            countingView?.isHidden = true

        }
    }
    
    
    
}

