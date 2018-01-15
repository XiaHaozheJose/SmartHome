//
//  JS_Speech.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation
import Speech
class JS_Speech: NSObject {
    
    // Singleton
    static let shared = JS_Speech()
    private override init(){
        self.audioEngine = AVAudioEngine()
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale.autoupdatingCurrent)
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            if status != SFSpeechRecognizerAuthorizationStatus.authorized{
                return
            }
        }
    }
    
    fileprivate var audioEngine: AVAudioEngine?
    fileprivate var speechRecognizer: SFSpeechRecognizer?
    fileprivate var speechRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var currentSpeechTask: SFSpeechRecognitionTask?
    fileprivate var isCancelSpeech: Bool = false
    
    
    
    
    
    
    func setIsCancelSpeech(_ isCancel: Bool){
        isCancelSpeech = isCancel
    }
    
    
    
    
    /// Start recording
    ///
    /// - Parameter finished: return result
    func startRecording(_ finished: @escaping (_ result: String)->()){
        
        if currentSpeechTask != nil {
            currentSpeechTask?.cancel()
            currentSpeechTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }catch{
            print("audioSession Error")
        }
        
        speechRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let intputNode = audioEngine?.inputNode else {
            fatalError("Audio Engine has no input node")
        }
        
        guard let request = speechRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest")
        }
        request.shouldReportPartialResults = true
        
        currentSpeechTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil{
                isFinal = (result?.isFinal)!
                if isFinal && !self.isCancelSpeech{
                    finished(result?.bestTranscription.formattedString ?? NULL)
                }
            }
            if error != nil || isFinal{
                self.audioEngine?.stop()
                self.speechRequest?.endAudio()
                intputNode.removeTap(onBus: 0)
                
                self.speechRequest = nil
                self.currentSpeechTask = nil
            }
        })
        
        let recordingFormat = intputNode.outputFormat(forBus: 0)
        
        intputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.speechRequest?.append(buffer)
        }
        audioEngine?.prepare()
        
        do {
            try audioEngine?.start()
        }catch{
            print("audioEngine Can't Start")
        }
        
    }
    
    
    /// stop Recording
    func stopSpeech(){
        audioEngine?.stop()
        speechRequest?.endAudio()
    }
}
