//
//  LSChatListCellViewModel.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/29.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSChatListCellViewModel: NSObject {

    var unReadCout: Int  = 0
    var icon: String = ""
    var name: String  = ""
    var message: String = ""
    var time: String = ""
    let (chatListCellClickSignal , observerGesture) = Signal<LSChatListCellViewModel?, NoError>.pipe()
}
