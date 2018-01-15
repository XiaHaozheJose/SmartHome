//
//  VoiceAnimation.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
class VoiceAnimation: UIView {
    
    fileprivate var imageContent: UIImageView?
    fileprivate var maskLayer: CAShapeLayer?
    var basicSize: CGSize = CGSize(width: 0, height: 0)
    
    func updateWithVoice(voicePower: Float) {
        print("voicePower" + "\(voicePower)")
        if imageContent == nil {
            self.imageContent = UIImageView()
            imageContent?.backgroundColor = UIColor.clear
            imageContent?.image = #imageLiteral(resourceName: "ic_record_ripple")
            self.addSubview(imageContent!)
        }
        imageContent?.frame = CGRect(x: 0, y: 0, width: basicSize.width, height: basicSize.height)
        
        var viewCount = Int(ceil(fabs(voicePower)*10))
        if viewCount == 0 {
            viewCount += 1
        }
        if viewCount > 9{
            viewCount = 9
        }
        
        if maskLayer == nil {
            maskLayer = CAShapeLayer()
            maskLayer?.backgroundColor = UIColor.black.cgColor
        }
        
        let itemHeiht = 3
        let itemPadding = 3
        let maskPadding = itemHeiht * viewCount + (viewCount - 1) * itemPadding
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: basicSize.height - CGFloat(maskPadding), width: basicSize.width, height: basicSize.height))
        maskLayer?.path = path.cgPath
        imageContent?.layer.mask = maskLayer
    }
    
}
