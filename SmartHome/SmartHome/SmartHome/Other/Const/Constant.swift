
//
//  Constant.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit


/// Status
///
/// - Normal: NULL >>>> 0
/// - Recording:   >>>> 1
/// - ReleaseToCancel:  >>>>>2
/// - RecordCounting:   >>>>>3
/// - RecordTooShort:   >>>>>4
enum VoiceRecordState: Int {
    case Normal
    case Recording
    case ReleaseToCancel
    case RecordCounting
    case RecordTooShort
}

/*
 Command
 */
//Abrir La Puerta
let kOpenDoorEn = "open the door"
let kOpenDoorEs = "abre la puerta"
let kOpenDoorCh = "开门"
let kCloseDoorEn = "close the door"
let kCloseDoorEs = "cierra la puerta"
let kCloseDoorCh = "关门"

//Key
let kCommandDoorOpen = "OPEN_DOOR"
let kCommandDoorClose = "CLOSE_DOOR"


// Enciende la Luz
let kOpenLuzEn = "turn on the light"
let kOpenLuzEs = "enciende la luz"
let kOpenLuzCh = "开灯"
let kCloseLuzEn = "turn off the light"
let kCloseLuzEs = "apaga la luz"
let kCloseLuzCh = "关灯"

//Key
let kCommandLedTurnOn = "LED_ON"
let kCommandLedTurnOFF = "LED_OFF"


/*
 Voice Argument
 */
let kFakeTimerDuration: Float = 0.2
let kMaxRecordDuration: Float = 10
let kRemainCountingDuration: Float = 0.5

/*
 UI
 */

let normalBgColor = UIColor(hexString: "#2A316F")!
let selectBgColor = UIColor(hexString: "#65CEFC")!
let kPulsesSound: UInt32 = 1521


/*
 Objeto -> JSON
 */
let TEMPERATURA = "field1"
let LIGHT = "field2"
let WATER = "field3"
let POSTBOX = "field4"
let DOOR = "field5"
let LED = "field6"
let NULL = "<null>"
/*
 URL TinkSpeak
 */

let api_key = "VPLPPJ3PJFLNLSSS"
let api_key_TalkBack = "MZ95S6M2PCUTHQLM"
let channel_id = "365135"
let urlTemperatura = "https://api.thingspeak.com/channels/" + "\(channel_id)" + "/fields/1.json?api_key="+"\(api_key)"+"&results=1"
let urlLight = "https://api.thingspeak.com/channels/" + "\(channel_id)" + "/fields/2.json?api_key="+"\(api_key)"+"&results=1"
let urlLed = "https://api.thingspeak.com/channels/" + "\(channel_id)" + "/fields/6.json?api_key="+"\(api_key)"+"&results=1"
let urlDoor = "https://api.thingspeak.com/channels/" + "\(channel_id)" + "/fields/5.json?api_key="+"\(api_key)"+"&results=1"
let urlWater = "https://api.thingspeak.com/channels/" + "\(channel_id)" + "/fields/3.json?api_key="+"\(api_key)"+"&results=1"


let urlAddCommand = "https://api.thingspeak.com/talkbacks/22419/commands.json"
let updateLedChannel = "https://api.thingspeak.com/update?api_key=CFDS9VCKW2QSTSUH&"+"\(LED)"+"="
let updateDoorChannel = "https://api.thingspeak.com/update?api_key=CFDS9VCKW2QSTSUH&"+"\(DOOR)"+"="

// LED ON PARAMETERS
let LED_ON_PARAMETERS = [
    "api_key":api_key_TalkBack,
    "position":"1",
    "command_string":kCommandLedTurnOn
]

// LED OFF PARAMETERS
let LED_OFF_PARAMETERS = [
    "api_key":api_key_TalkBack,
    "position":"1",
    "command_string":kCommandLedTurnOFF
]

// DOOR OPEN PARAMETERS
let DOOR_OPEN_PARAMETERS = [
    "api_key":api_key_TalkBack,
    "position":"1",
    "command_string":kCommandDoorOpen
]

// DOOR CLOSE PARAMETERS
let DOOR_CLOSE_PARAMETERS = [
    "api_key":api_key_TalkBack,
    "position":"1",
    "command_string":kCommandDoorClose
]
