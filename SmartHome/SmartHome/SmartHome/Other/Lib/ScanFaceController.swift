//
//  ScanFaceController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class ScanFaceController: UIViewController {

    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var topConstaint: NSLayoutConstraint!
    @IBOutlet weak var scanView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        startScan()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension ScanFaceController{
    
    fileprivate func startAnimation(){
        topConstaint.constant = -scanImageView.bounds.height
        view.layoutIfNeeded()
        UIView.animate(withDuration: 2) {
            self.topConstaint.constant = self.scanImageView.bounds.height
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }
    
    /// 开始扫描
    fileprivate func startScan() {
        JS_CoreImage.shared.detect(scanView: scanView, displayView: view) {
        }
    }
}
