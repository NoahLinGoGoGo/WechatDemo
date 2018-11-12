//
//  LSChatViewModel.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/14.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

enum RecordBtnEvent : Int {
    
    case touchDown
    case touchUpOutside
    case touchUpInside
    case touchDragExit
    case touchDragEnter
}

class LSChatViewModel: LSBaseReqViewModel {
    
    let texts: Array<String> = ["在吗","6月19日，武汉市动物园官微通报称，对网友反映的饲养员在工作时间出现的问题深感抱歉，已让涉事饲养员停职检查并调离岗位，并安排更具专业知识、爱心和责任心的管理员照顾伟伟的生活。","在干嘛","吃饭没"]
    
    var dataArray: Array<LSChatCellViewModel> = Array()
    var userViewModel: LSChatListCellViewModel?
    
//    let (chatListClickSignal , observerCellClick) = Signal<LSChatListViewModel, NoError>.pipe()
    let (bottomBarVoiceBtnClickSignal , observerBottomBarVoiceBtnClickEvent) = Signal<RecordBtnEvent, NoError>.pipe()
    let (bottomBarBgClearCoverBtnClickSignal , observerBottomBarBgClearCoverBtnClick) = Signal<LSChatCellViewModel, NoError>.pipe()
    let (bottomBarTextViewIsEditingSignal , observerBottomBarTextViewIsEditing) = Signal<CGFloat, NoError>.pipe()
    let (bottomBarTextViewDidClickSendSignal , observerBottomBarTextViewDidClickSend) = Signal<String, NoError>.pipe()
    
    override func getChatArray() -> SignalProducer<Any, NoError> {
        
        return SignalProducer<Any, NoError>.init { (observer, _) in
            
            self.request.GET(url: Host, paras: nil, success: { (request, response) in
                
                if let response = response {
                    self.dataArray = self.WebArray()
                    observer.send(value: response)
                    observer.sendCompleted()
                }
                
            }, failure: { (request, error) in
                
                observer.sendCompleted()
            })
            
        }
    }
    
    
    func WebArray() -> Array<LSChatCellViewModel> {
        var arr: Array<LSChatCellViewModel> = []
        for index in 0...20 {
            
            switch index {
            case 0,2,4:
                let viewModel = LSChatCellViewModel(msgType: .textMsg, isFromSelf: false)
                viewModel.id =  String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
                viewModel.textContent = randomObject(array: texts)
                arr.append(viewModel)
            case 1,3:
                let viewModel = LSChatCellViewModel(msgType: .textMsg, isFromSelf: true)
                viewModel.id =  String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
                viewModel.textContent = randomObject(array: texts)
                arr.append(viewModel)
            case 5:
                let viewModel = LSChatCellViewModel(msgType: .imageMsg, isFromSelf: true)
                viewModel.id =  String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
                viewModel.imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529476983835&di=a4305f89027a575a62ccc2a1c0d3766a&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F34fae6cd7b899e51a06e25944ea7d933c9950d49.jpg"
                arr.append(viewModel)
            case 6:
                let viewModel = LSChatCellViewModel(msgType: .imageMsg, isFromSelf: false)
                viewModel.id =  String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
                viewModel.imageUrl = "https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=254b5229c5177f3e0f34fa0d40ce3bb9/4afbfbedab64034f8c730299a3c379310b551df7.jpg"
                arr.append(viewModel)
            default:
                print("")
            }
            
        }
        return arr
    }
}
