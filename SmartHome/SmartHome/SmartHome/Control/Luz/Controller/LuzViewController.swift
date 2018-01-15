//
//  LuzViewController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
class LuzViewController: UIViewController {
    
    
    // MARK: - Variable
    lazy fileprivate var recordCtrl: VoiceRecordController = {
        let record = VoiceRecordController()
        return record
    }()
    
    @IBOutlet weak var LedStatus: UIButton!
    @IBOutlet weak var voiceBtn: VoiceButton!
    @IBOutlet weak var luzSwitch: UISwitch!
    @IBOutlet weak var errorLog: UILabel!
    fileprivate var activity: UIActivityIndicatorView = {
        let acti = UIActivityIndicatorView()
        acti.hidesWhenStopped = true
        return acti
    }()
    fileprivate var currentRecordState: VoiceRecordState?
    fileprivate var canceled: Bool = false
    fileprivate var duration: Float = 0.0
    fileprivate var fakeTimer: Timer?
    fileprivate var isCancelSpeech: Bool = false
    fileprivate var speech = JS_Speech.shared

    fileprivate var isOpened: Bool?{
        didSet{
            self.activity.stopAnimating()
            if isOpened == true{
                self.LedStatus.isSelected = true
                self.luzSwitch.isOn = true
            }else{
                self.LedStatus.isSelected = false
                self.luzSwitch.isOn = false
        }
        }}
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getStatusFromThingSpeak()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func didChangeValueSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            addCommandToThingSpeak(paramas: LED_ON_PARAMETERS, status: true)
        }else{
            addCommandToThingSpeak(paramas: LED_OFF_PARAMETERS, status: false)
        }
    }
    
    
    @IBAction func touchInside(_ sender: UIButton) {
        if canceled {
            return
        }
        if duration < kRemainCountingDuration {
            recordCtrl.showToast(message: "Message Too Short")
        }else{}
        speech.setIsCancelSpeech(false)
        currentRecordState = VoiceRecordState.Normal
        dispatchVoiceState()
        speech.stopSpeech()
    }
    
    @IBAction func dragInside(_ sender: UIButton) {
        if canceled {
            return
        }
        currentRecordState = VoiceRecordState.Recording
        dispatchVoiceState()
        
    }
    
    @IBAction func dragOutside(_ sender: UIButton) {
        if canceled {
            return
        }
        currentRecordState = VoiceRecordState.ReleaseToCancel
        dispatchVoiceState()
        
    }
    
    @IBAction func touchOutside(_ sender: UIButton) {
        if canceled {
            return
        }
        speech.setIsCancelSpeech(true)
        currentRecordState = VoiceRecordState.Normal
        dispatchVoiceState()
        speech.stopSpeech()
    }
    
    
    /// Speech Voz
    @IBAction func touchDown(_ sender: UIButton) {
        currentRecordState = VoiceRecordState.Recording
        dispatchVoiceState()
        AudioServicesPlaySystemSound(kPulsesSound)
        speech.startRecording { (result) in
            //判断
            if result.uppercased() == kOpenLuzEn.uppercased() || result.uppercased() == kOpenLuzEs.uppercased() || result.uppercased() == kOpenLuzCh.uppercased(){
                if self.luzSwitch.isOn == true {return}
                // Command To Open The Light
                self.addCommandToThingSpeak(paramas: LED_ON_PARAMETERS, status: true,isVoice: true)
            }else if result.uppercased() == kCloseLuzEn.uppercased() || result.uppercased() == kCloseLuzEs.uppercased() || result.uppercased() == kCloseLuzCh.uppercased(){
                if self.luzSwitch.isOn == false {return}
                // Command To CLose The Light
                self.addCommandToThingSpeak(paramas: LED_OFF_PARAMETERS, status: false,isVoice: true)
            }
        }
    }
    
    
    
    /// Update Animation State
    private func dispatchVoiceState(){
        guard let recordStatus = currentRecordState else {return}
        if recordStatus == .Recording {
            canceled = false
            startFakeTimer()
        }else if recordStatus == .Normal{
            resertStatus()
        }
        voiceBtn.updateWithRecordStatus(state: recordStatus)
        recordCtrl.updateUIWithRecordState(state: recordStatus)
    }
    
    private func startFakeTimer(){
        if fakeTimer == nil {
            fakeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(kFakeTimerDuration), target: self, selector: #selector(onFakeTimer), userInfo: nil, repeats: true)
            fakeTimer?.fire()
        }
    }
    
    @objc private func onFakeTimer(){
        duration += kFakeTimerDuration
        print(duration)
        let remainTime = kMaxRecordDuration - duration
        if remainTime == 0 {
            currentRecordState = .Normal
            dispatchVoiceState()
        }else if shouldShowCounting(){
            currentRecordState = .RecordCounting
            dispatchVoiceState()
            recordCtrl.showRecordCounting(remainTime: remainTime)
        }else{
            let fakePower = Float.random(lower: 0, 1)
            recordCtrl.updateWithPower(power: fakePower)
        }
    }
    
    private func resertStatus(){
        stopFakeTimer()
        duration = 0.0
        canceled = true
    }
    
    private func stopFakeTimer(){
        fakeTimer?.invalidate()
        fakeTimer = nil
    }
    
    private func shouldShowCounting()->Bool{
        if duration >= kMaxRecordDuration - kRemainCountingDuration && duration < kMaxRecordDuration && currentRecordState != .ReleaseToCancel{
            return true
        }else {
            return false
        }
    }
}



// MARK: - Set UI
extension LuzViewController{
    fileprivate func setUI(){
        self.title = "Luz"
        errorLog.layer.cornerRadius = 10
        errorLog.layer.masksToBounds = true
        errorLog.alpha = 0.0
        
        voiceBtn.layer.cornerRadius = 5
        voiceBtn.layer.masksToBounds = true
        voiceBtn.layer.borderWidth = 0.5
        voiceBtn.layer.borderColor = UIColor.init(hexString: "0xA3A5AB")?.cgColor
        
        activity.center = LedStatus.center
        activity.color = UIColor(hexString: "#2A316F")
        self.view.addSubview(activity)
    }
}


// MARK: - Request HTTPS
extension LuzViewController{
    
    /// Submit Status Of The Led
    ///
    /// - Parameter status: The Led State
    fileprivate func subirStatusToThingSpeak(status: Bool){
        UserDefaults.standard.set(status, forKey: LED)
        UserDefaults.standard.synchronize()
        getStatusFromThingSpeak()
    }
    
    /// Get The Led State
    fileprivate func getStatusFromThingSpeak(){
        if let status = UserDefaults.standard.object(forKey: LED){
            isOpened = status as? Bool
        }else{
            isOpened = false
        }
    }
    
    
    
    
    /// Add Command To TalkBack
    ///
    /// - Parameter paramas: Paramaters
    fileprivate func addCommandToThingSpeak(paramas: [String :String], status: Bool, isVoice: Bool = false){
        activity.startAnimating()
        NetWorkRequest.sharedInstance.postRequestFormToDict(urlString: urlAddCommand, params: paramas, success: { (response) in
            if let create = response["created_at"] as? String{
                if create != ""{
                    self.subirStatusToThingSpeak(status: status)
                }}
        }) { (error) in
            if !isVoice{ self.statusToSwitch(isOn: !self.luzSwitch.isOn )}
            self.activity.stopAnimating()
            UIView.animate(withDuration: 3.0, animations: {
                self.errorLog.alpha = 0.8
            }, completion: { (finish) in
                UIView.animate(withDuration: 1.0, animations: {
                    self.errorLog.alpha = 0.0
                })
            })
            print(error)
        }
    }
    
    
    /// status Switch
    private func statusToSwitch(isOn: Bool){
        self.luzSwitch.isOn = isOn
    }
    
}

// MARK: - Ramdom Float
extension Float {
    
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}
