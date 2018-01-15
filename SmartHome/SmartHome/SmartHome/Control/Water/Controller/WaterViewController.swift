//
//  WaterViewController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/13.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import UICircularProgressRing
class WaterViewController: UIViewController {

    
    fileprivate var water: Water?{
        didSet{
            if water?.field3 == ""{
                water?.field3 = "30.30"
            }
            
            let float = Float(water!.field3)
            setWaterState(nivel: float!)
            progressWater.setProgress(value: CGFloat(float!), animationDuration: 2.0)
        }
    }
    fileprivate var time: JS_Timer?
    @IBOutlet weak var waterState: UILabel!
    @IBOutlet weak var progressWater: UICircularProgressRingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Water"
        view.backgroundColor = normalBgColor
        time = JS_Timer(interval: 5.0, repeats: true, repeatRun: {
            self.httpConnection()
        })
        time?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        invalidTime()
    }
    deinit {
        invalidTime()
    }
    
    fileprivate func invalidTime(){
        time?.close()
        time = nil
    }

    fileprivate func setWaterState(nivel: Float){
        if nivel < 15 {
            waterState.text = "Esta Vacia"
        }else if nivel > 15 && nivel < 65{
            waterState.text = "Se Esta Llenando"
        }else if nivel > 65 && nivel < 101{
            waterState.text = "Esta Lleno"
        }else{
            waterState.text = "Esta Roto LLama Al Tecnico "
        }
    }
}

extension WaterViewController{
        @objc fileprivate func httpConnection(){
            print("water")
            NetWorkRequest.sharedInstance.getRequestToAnyObject(urlString: urlWater, success: {[weak self] (response: [String: AnyObject]) in
                if let feeds = response["feeds"] as? [AnyObject]{
                    guard let field = feeds.first as? [String: AnyObject] else{return}
                    self?.water = Water(dict: field)
                }
                }, failture: { (error) in
                    self.invalidTime()
                    print(error)
            })
        }

}
