//
//  TempYLightController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import UICircularProgressRing


class TempYLightController: UIViewController {
    
    
    /**
     *
     **/
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var currentTmp: UILabel!
    @IBOutlet weak var funTmp: UIButton!
    @IBOutlet weak var hotTmp: UIButton!
    @IBOutlet weak var coolTmp: UIButton!
    @IBOutlet weak var circularTmp: UICircularProgressRingView!
    fileprivate var isTemperaturaOn = false
    fileprivate var time: JS_Timer?
    @IBOutlet weak var segment: UISegmentedControl!
    fileprivate var isFirstViewLoad: Bool = true
    var temperatura: Temperatura?{
        didSet{
            if temperatura?.field1 == "" {
                temperatura?.field1 = "11.11"
            }
            currentTmp.text = "\(temperatura!.field1)" + "°C"
            setTmpNivel(temp: temperatura!.field1)
            let float = Float(temperatura!.field1)
            circularTmp.setProgress(value: CGFloat(float!), animationDuration: 0.25)
        }
    }
    
    // MARK: - Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        isTemperaturaOn = true
        inicialUI()
        startLoop()
    }
    
   // didDisAppear
    override func viewDidDisappear(_ animated: Bool) {
        time?.close()
        time = nil
    }
   // DidAppear
    override func viewDidAppear(_ animated: Bool) {
        startLoop()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    deinit {
        print("deinit")
        time?.close()
        time = nil
    }
    
    // Button To Start And Stop
    @IBAction func startLeerTem(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isTemperaturaOn = !isTemperaturaOn
        isTemperaturaOn == true ? startLoop() : time?.stop()
    }
    
    // Change View To Light
    @IBAction func changeTmpYLight(_ sender: UISegmentedControl) {
        let light = LightViewController()
        light.modalTransitionStyle = .partialCurl
        present(light, animated: true) {
            sender.selectedSegmentIndex = 0
        }
    }
}


// MARK: - UI Y HttpClient
extension TempYLightController{
    fileprivate func inicialUI(){
        self.title = "TempYLight"
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.layer.masksToBounds = true
        httpConnection()
    }
    
    // Loop HttpConnection
    fileprivate func startLoop(){
        if time == nil {
            time = JS_Timer(interval: 5, repeats: true) {
                DispatchQueue.main.async {
                    self.httpConnection()
                }
            }
            time?.start()
        }else{
            time?.resume()
        }
    }
    
    // HttpConnection
    @objc fileprivate func httpConnection(){
        print("tempHttp")
            NetWorkRequest.sharedInstance.getRequestToAnyObject(urlString: urlTemperatura, success: {[weak self] (response: [String: AnyObject]) in
                if let feeds = response["feeds"] as? [AnyObject]{
                    guard let field = feeds.first as? [String: AnyObject] else{return}
                    self?.temperatura = Temperatura(dict: field)
                }
                }, failture: { (error) in
                    self.time?.stop()
                    print(error)
            })
    }
    
    // Status Button For Temp
    fileprivate func setTmpNivel(temp: String){
        guard let temp = Float(temp) else {return}
        if temp < 15 {
            coolTmp.isSelected = true
            funTmp.isSelected = false
            hotTmp.isSelected = false
        }else if temp >= 15 && temp <= 25{
            coolTmp.isSelected = false
            funTmp.isSelected = true
            hotTmp.isSelected = false
        }else {
            coolTmp.isSelected = false
            funTmp.isSelected = false
            hotTmp.isSelected = true
        }
    }
    
    
    
}
