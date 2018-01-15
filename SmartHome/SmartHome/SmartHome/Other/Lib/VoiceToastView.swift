//
//  VoiceToastView.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
class VoiceToastView: UIView {

    // MARK: - Recording
    class VoiceRecordingView: VoiceToastView {
        fileprivate var imageRecord: UIImageView?
        fileprivate var lbContent: UILabel?
        fileprivate var voiceAnimation: VoiceAnimation?
        
        
        convenience init() {
            self.init()
            setUP()
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUP()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// UI
        private func setUP(){
            if lbContent == nil {
                lbContent = UILabel(frame: self.bounds)
                lbContent?.backgroundColor = .clear
                lbContent?.text = "Slide up to cancel"
                lbContent?.textColor = .white
                lbContent?.textAlignment = .center
                lbContent?.font = UIFont.systemFont(ofSize: 14)
                self.addSubview(lbContent!)
            }
            if imageRecord == nil {
                imageRecord = UIImageView()
                imageRecord?.backgroundColor = .clear
                imageRecord?.image = #imageLiteral(resourceName: "ic_record")
                self.addSubview(imageRecord!)
            }
            if voiceAnimation == nil{
                voiceAnimation = VoiceAnimation()
                voiceAnimation?.backgroundColor = .clear
                self.addSubview(voiceAnimation!)
            }
            
            guard let textSize = lbContent?.sizeThatFits(CGSize.zero) else {return}
            lbContent!.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-12)
                make.size.height.equalTo(ceil(textSize.height))
            }
            
            imageRecord!.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(30)
                make.leading.equalTo(self).offset(40)
                make.size.equalTo(CGSize(width: (imageRecord?.image?.size.width)!, height: (imageRecord?.image?.size.height)!))
            }
            
            let voiceSize = CGSize(width: 18, height: 56)
            voiceAnimation?.snp.makeConstraints({ (make) in
                make.bottom.equalTo(imageRecord!)
                make.leading.equalTo(imageRecord!.snp.trailing).offset(4)
                make.size.equalTo(voiceSize)
            })
            
            voiceAnimation?.basicSize = voiceSize
            voiceAnimation?.updateWithVoice(voicePower: 0)
        }
        
        func updateWithPower(power: Float){
            voiceAnimation?.updateWithVoice(voicePower: power)
        }
        
    }
   
    // MARK: - RecordTip
    class VoiceRecordTip: VoiceToastView {
        fileprivate var imageRecord: UIImageView?
        fileprivate var lbContent: UILabel?
        
        
        convenience init() {
            self.init()
            setUP()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUP()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUP(){
            self.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
            self.layer.cornerRadius = 6
            self.layer.masksToBounds = true
            if lbContent == nil {
                lbContent = UILabel(frame: self.bounds)
                lbContent?.backgroundColor = .clear
                lbContent?.text = "Message Too Short"
                lbContent?.textColor = .white
                lbContent?.textAlignment = .center
                lbContent?.font = UIFont.systemFont(ofSize: 14)
                self.addSubview(lbContent!)
            }
            if imageRecord == nil {
                imageRecord = UIImageView()
                imageRecord?.backgroundColor = .clear
                imageRecord?.image = #imageLiteral(resourceName: "ic_record_too_short")
                self.addSubview(imageRecord!)
            }
    }
        
        func showMessage(message: String){
            lbContent?.text = message
            
            imageRecord!.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(30)
                make.centerX.equalTo(self)
                make.size.equalTo(CGSize(width: (imageRecord?.image?.size.width)!, height: (imageRecord?.image?.size.height)!))
            }
            guard let textSize = lbContent?.sizeThatFits(CGSize.zero) else {return}
            lbContent!.snp.updateConstraints { (make) in
                make.leading.equalTo(self)
                make.trailing.equalTo(self)
                make.bottom.equalToSuperview().offset(-12)
                make.size.height.equalTo(ceil(textSize.height))
            }
            
        }
        
    
}
    // MARK: - RecordCountingView
    class VoiceRecordCountingView: VoiceToastView {
        fileprivate var lbRemainTime: UILabel?
        fileprivate var lbContent: UILabel?
        
        convenience init(){
            self.init()
            setUP()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUP()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        /// UI
        private func setUP(){
            if lbContent == nil {
                lbContent = UILabel(frame: self.bounds)
                lbContent?.backgroundColor = UIColor(hexString: "0xA52E2C")
                lbContent?.text = "Release To Cancel"
                lbContent?.textColor = .white
                lbContent?.textAlignment = .center
                lbContent?.font = UIFont.systemFont(ofSize: 14)
                lbContent?.layer.cornerRadius = 2
                lbContent?.clipsToBounds = true
                self.addSubview(lbContent!)
            }
            
            if lbRemainTime == nil{
                lbRemainTime = UILabel()
                lbRemainTime?.backgroundColor = .clear
                lbRemainTime?.font = UIFont.boldSystemFont(ofSize: 80)
                lbRemainTime?.textColor = .white
                self.addSubview(lbRemainTime!)
            }
            lbContent?.snp.updateConstraints({ (make) in
                make.leading.equalTo(self).offset(3)
                make.trailing.equalTo(self).offset(-3)
                make.bottom.equalTo(self).offset(-7)
                make.size.height.equalTo(25)
            })
        }
        
        
        // updateTime
        func updateWithRemainTime(remainTIme: Float){
           lbRemainTime?.text = "\(Int(remainTIme))"
            let textSize = lbRemainTime?.sizeThatFits(CGSize.zero)
            lbRemainTime?.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(16)
                make.centerX.equalTo(self)
                make.size.equalTo(CGSize(width: ceil(textSize!.width), height: 95))
            })
        }
    }
    
    
   // MARK: - RecordReleaseToCancel
    class VoiceReleaseToCancel: VoiceToastView {
        fileprivate var imageRelease: UIImageView?
        fileprivate var lbContent: UILabel?
        
        convenience init(){
            self.init()
            setUP()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUP()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        /// UI
        private func setUP(){
            if lbContent == nil {
                lbContent = UILabel(frame: self.bounds)
                lbContent?.backgroundColor = UIColor(hexString: "0xA52E2C")
                lbContent?.text = "Release To Cancel"
                lbContent?.textColor = .white
                lbContent?.textAlignment = .center
                lbContent?.font = UIFont.systemFont(ofSize: 14)
                lbContent?.layer.cornerRadius = 2
                lbContent?.clipsToBounds = true
                self.addSubview(lbContent!)
            }
            
            if imageRelease == nil{
                imageRelease = UIImageView()
                imageRelease?.backgroundColor = .clear
                imageRelease?.image = #imageLiteral(resourceName: "ic_release_to_cancel")
                self.addSubview(imageRelease!)
               
            }
            imageRelease?.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(30)
                make.centerX.equalTo(self)
                make.size.equalTo(CGSize(width: (imageRelease?.image?.size.width)!, height: (imageRelease?.image?.size.height)!))
            })
            
            lbContent?.snp.updateConstraints({ (make) in
                make.leading.equalTo(self).offset(3)
                make.trailing.equalTo(self).offset(-3)
                make.bottom.equalTo(self).offset(-7)
                make.size.height.equalTo(25)
            })
        }
        
    }
    
}
