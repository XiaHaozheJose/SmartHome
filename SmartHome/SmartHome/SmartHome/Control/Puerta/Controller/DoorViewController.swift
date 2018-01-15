//
//  DoorViewController.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AVFoundation
import Speech

class DoorViewController: UIViewController {
    
    // MARK: - Variable
    lazy fileprivate var recordCtrl: VoiceRecordController = {
        let record = VoiceRecordController()
        return record
    }()
    
    fileprivate var isOpened: Bool?{
        didSet{
            self.activity.stopAnimating()
            if isOpened == true {
                self.doorStatus.isSelected = true
                self.doorSwitch.isOn = true
            }else{
                self.doorStatus.isSelected = false
                self.doorSwitch.isOn = false
            }
        }
    }
   lazy fileprivate var activity: UIActivityIndicatorView = {
        let acti = UIActivityIndicatorView()
        acti.hidesWhenStopped = true
        return acti
    }()
    
    @IBOutlet weak var doorSwitch: UISwitch!
    @IBOutlet weak var doorStatus: UIButton!
    @IBOutlet weak var welcomeImage: UIImageView!
    @IBOutlet weak var voiceBtn: VoiceButton!
    
    fileprivate var currentRecordState: VoiceRecordState?
    fileprivate var canceled: Bool = false
    fileprivate var duration: Float = 0.0
    fileprivate var fakeTimer: Timer?
    fileprivate var isCancelSpeech: Bool = false
    fileprivate var speech = JS_Speech.shared
    fileprivate var isAnimationing: Bool = false

    
    lazy var anim: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 1
        anim.repeatCount = 2
        anim.isRemovedOnCompletion = true
        return anim
    }()
    
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        getStatusFromThingSpeak()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func changedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            addCommandToThingSpeak(paramas: DOOR_OPEN_PARAMETERS, status: true)
        }else{
            addCommandToThingSpeak(paramas: DOOR_CLOSE_PARAMETERS, status: false)
        }
    }
    
}


// MARK: - Set UI
extension DoorViewController{
    fileprivate func setUI(){
        self.title = "Door"
        voiceBtn.layer.cornerRadius = 5
        voiceBtn.layer.masksToBounds = true
        voiceBtn.layer.borderWidth = 0.5
        voiceBtn.layer.borderColor = UIColor.init(hexString: "0xA3A5AB")?.cgColor
        
        activity.center = doorStatus.center
        self.view.addSubview(activity)
        
    }

}

// MARK: - Touch To Speech
extension DoorViewController{
    
    @IBAction func touchInside(_ sender: UIButton) {
        if canceled {
            return
        }
        
        if duration < 3 {
            recordCtrl.showToast(message: "Message Too Short")
        }else{
            print("uploadVoice")
        }
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
        if isAnimationing {
            return
        }
        currentRecordState = VoiceRecordState.Recording
        dispatchVoiceState()
        AudioServicesPlaySystemSound(kPulsesSound)
        speech.startRecording { (result) in
            if result.uppercased() == kOpenDoorEn.uppercased() || result.uppercased() == kOpenDoorEs.uppercased() || result.uppercased() == kOpenDoorCh.uppercased(){
                // Command To Open The Door
                if self.doorSwitch.isOn == true {return}
                self.addCommandToThingSpeak(paramas: DOOR_OPEN_PARAMETERS, status: true)
            }else if result.uppercased() == kCloseDoorEn.uppercased() || result.uppercased() == kCloseDoorEs.uppercased() || result.uppercased() == kCloseDoorCh.uppercased(){
                // Command To CLose The Door
                if self.doorSwitch.isOn == false {return}
                self.addCommandToThingSpeak(paramas: DOOR_CLOSE_PARAMETERS, status: false)
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
    
    /// Start Timer
    private func startFakeTimer(){
        if fakeTimer == nil {
            fakeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(kFakeTimerDuration), target: self, selector: #selector(onFakeTimer), userInfo: nil, repeats: true)
            fakeTimer?.fire()
        }
    }
    
    /// Start Count Timer
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
    
    
    /// Resert Timer
    private func resertStatus(){
        stopFakeTimer()
        duration = 0.0
        canceled = true
    }
    
    /// Stop Timer
    private func stopFakeTimer(){
        fakeTimer?.invalidate()
        fakeTimer = nil
    }
    
    /// Show Timer
    private func shouldShowCounting()->Bool{
        if duration >= kMaxRecordDuration - kRemainCountingDuration && duration < kMaxRecordDuration && currentRecordState != .ReleaseToCancel{
            return true
        }else {
            return false
        }
    }
}


// MARK: - Https Request
// MARK: - Request HTTPS
extension DoorViewController{
    
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
        NetWorkRequest.sharedInstance.postRequest(urlString: urlAddCommand, params:paramas as [String : AnyObject], data: nil, name: nil, success: { (result) in
            if let create = result["created_at"] as? String{
                if create != ""{
                    self.subirStatusToThingSpeak(status: status)
                }}
        }, failture: { (error) in
            if !isVoice{ self.statusToSwitch(isOn: !self.doorSwitch.isOn )}
            self.activity.stopAnimating()
            print(error)
        })
    }
    
    /// status Switch
    private func statusToSwitch(isOn: Bool){
        self.doorSwitch.isOn = isOn
    }
    
    }
