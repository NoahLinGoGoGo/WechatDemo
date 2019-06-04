//
//  LSChatModel.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatListModel: NSObject {
    var unReadCout: Int  = 0
    var icon: String = ""
    var name: String = ""
    var message: String = ""
    var time: String = ""
    
    convenience init(unReadCout: Int, icon: String, name: String, message: String, time: String) {
        self.init()
        
        self.unReadCout = unReadCout
        self.icon = icon
        self.name = name
        self.message = message
        self.time = time
    }
    
    
}
