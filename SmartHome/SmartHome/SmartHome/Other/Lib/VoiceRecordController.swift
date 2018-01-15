//
//  VoiceRecordController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class VoiceRecordController: NSObject {
    
    lazy fileprivate var voiceRecordView: VoiceRecordView = {
       let record = VoiceRecordView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        record.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        return record
    }()
    
    lazy  fileprivate var tipView: VoiceToastView.VoiceRecordTip = {
        let tip = VoiceToastView.VoiceRecordTip(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        tip.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        return tip
    }()
    
    
    func updateWithPower(power: Float){
        self.voiceRecordView.updatePower(power: power)
    }
    
    func showRecordCounting(remainTime: Float){
        self.voiceRecordView.updateWithRemainTime(remainTIme: remainTime)
    }
    
    func showToast(message: String){
        if tipView.superview == nil{
            UIApplication.shared.keyWindow?.addSubview(tipView)
            self.tipView.showMessage(message: message)
            DispatchQueue.main.asyncAfter(deadline:.now() + 2){
                self.tipView.removeFromSuperview()
            }
        }
    }
    
    func updateUIWithRecordState(state: VoiceRecordState){
        if  state == .Normal {
            if self.voiceRecordView.superview != nil{
                self.voiceRecordView.removeFromSuperview()
            }
            return
        }
        if self.voiceRecordView.superview == nil{
            UIApplication.shared.keyWindow?.addSubview(self.voiceRecordView)
        }
        self.voiceRecordView.updateUIWithRecordState(state: state)
    }
    
}
