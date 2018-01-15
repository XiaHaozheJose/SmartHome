//
//  LightViewController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/3.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import UICircularProgressRing
class LightViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var percentLight: UILabel!
    @IBOutlet weak var progressLight: UICircularProgressRingView!
    @IBOutlet weak var lightStatus: UIButton!
    fileprivate var time: JS_Timer?
    fileprivate var isLightTurnOn: Bool = true
    fileprivate var light: Light?{
        didSet{
            if light?.field2 == ""{
                light?.field2 = "30.5"
            }
            percentLight.text = "\(light!.field2)" + "%"
            setLightStatus(light: light!.field2)
            let float = Float(light!.field2)
            progressLight.setProgress(value: CGFloat(float!), animationDuration: 0.25)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpConnection()
        startLoop()
    }

    override func viewDidDisappear(_ animated: Bool) {
        invalidTime()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startConnection(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isLightTurnOn = !isLightTurnOn
        isLightTurnOn == true ? startLoop() : invalidTime()
    }
    

    @IBAction func ChangeView(_ sender: UISegmentedControl) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func startLoop(){
        if time == nil {
            time = JS_Timer(interval: 5, repeats: true, repeatRun: {
                DispatchQueue.main.async {
                    self.httpConnection()
                }
            })
            time?.start()
        }
        
    }
    
    fileprivate func setLightStatus(light: String){
        guard let lig = Float(light) else {return}
        if lig > 20 {
            lightStatus.isSelected = true
        }else {
            lightStatus.isSelected = false
        }
    }
    
    fileprivate func invalidTime(){
        time?.close()
        time = nil
    }
}

extension LightViewController{
    @objc fileprivate func httpConnection(){
        print("lighthttp")
        NetWorkRequest.sharedInstance.getRequestToAnyObject(urlString: urlLight, success: {[weak self] (response: [String: AnyObject]) in
            if let feeds = response["feeds"] as? [AnyObject]{
                guard let field = feeds.first as? [String: AnyObject] else{return}
                self?.light = Light(dict: field)
            }
            }, failture: { (error) in
                self.invalidTime()
                print(error)
        })
    }
}
