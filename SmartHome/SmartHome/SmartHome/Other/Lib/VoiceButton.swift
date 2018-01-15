//
//  VoiceButton.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class VoiceButton: UIButton {

    func updateWithRecordStatus(state: VoiceRecordState){
        self.setTitle("Hold To Talk", for: .normal)
        self.setBackgroundImage(UIImage.imageWithColor(color: .white, size: CGSize(width: 1, height: 1)), for: .normal)
        
        if state == .Recording || state == .RecordCounting {
            setButtonWithString(message: "Release To Send", colorHex: "0xC6C7CA")
        }else if state == .ReleaseToCancel{
            self.setButtonWithString(message: "Hold To Talk", colorHex: "0xC6C7CA")
        }
    }

    private func setButtonWithString(message: String,colorHex: String){
        self.setTitle(message, for: .normal)
        self.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(hexString: colorHex) ?? .white, size: CGSize(width: 1, height: 1)), for: .normal)
    }
    
}

extension UIImage{
    class func imageWithColor(color: UIColor,size: CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        color.set()
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}
