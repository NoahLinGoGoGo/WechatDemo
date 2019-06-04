//
//  LSChatCellViewModel.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/2.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatCellViewModel: NSObject {

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
    var id: String?
    
    var textContent: String = ""
    
    var imageUrl: String = ""
    
    var voiceLength: Int = 0
    
    init(msgType: LSChatMsgType, isFromSelf: Bool)  {
        self.msgType = msgType
        self.isFromSelf = isFromSelf
    }
}
