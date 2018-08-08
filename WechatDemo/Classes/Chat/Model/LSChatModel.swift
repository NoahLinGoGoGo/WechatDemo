//
//  LSChatModel.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/14.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatModel: NSObject {
    
    enum LSChatMsgType : Int {
        
        case timeMsg = -2 //时间类消息
        case unDefineMsg = -1 //未定义消息
        case textMsg = 0 //文本消息
        case imageMsg = 1 //图片类消息
        case locationMsg = 2 //地理位置信息
        case voiceMsg = 3 //语音消息
        case atMsg = 4 //AT消息
        case cancleMsg = 5 //撤销消息
        case gifMsg = 6 //动作表情消息
        case cardMsg = 7 //名片消息
        case activityMsg = 8 //活动消息
        case movieMsg = 9
        case fileMsg = 10
    }
    
    var msgType: LSChatMsgType = .unDefineMsg
    var isFromSelf: Bool = false
    
    
    
    var textContent: String = ""
    
    var imageUrl: String = ""
    
   
    
    init(msgType: LSChatMsgType, isFromSelf: Bool)  {
        
    }
    
}
