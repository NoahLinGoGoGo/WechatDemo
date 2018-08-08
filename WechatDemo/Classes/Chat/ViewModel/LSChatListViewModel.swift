//
//  LSChatListViewModel.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/12.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSChatListViewModel: LSChatBaseModel {
    
    
    var dataArray: Array<LSChatListCellViewModel> = Array()
    let (chatListCellClickSignal , observerGesture) = Signal<LSChatListCellViewModel?, NoError>.pipe()
    
    var messages = ["这周末有空吗","你好","据最近消息称，布基纳法索已经在昨日与台湾当局断交","好的呀","[语音]","据说这是最新的iPhone X","你好","三星与中兴和解","WWDC2018盛大开幕","在吗","[文件]","你好","[链接]","美国与中兴达成和解","🐔鸡","最近怎么样","在干嘛"]
    let names = ["微风细雨","百度CEO李彦宏","爸爸","弟弟","迈阿密","科比","大大大","嘿嘿嘿","花非花","起个名字好难","强迫症患者","真TM无聊的一批","来呀，造作啊","好呀呀呀","我是一只🐖","我还是只单身🐶","我是猪脚","我是男猪脚","童话里没有男猪脚","哈哈哈哈","王者","财哥","美女主管","僚机"]
    
    var totalUnReadCount: Int  = 0
    
    func nowTime() -> String {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date as Date) as String
    }
    
    
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
    
    
    func WebArray() -> Array<LSChatListCellViewModel> {
        
        var arr: Array<LSChatListCellViewModel> = []
        for index in 0...20 {
            
            let data =  LSChatListCellViewModel()
            data.name = randomObject(array: names)
            data.message = randomObject(array: messages)
            data.icon = String.init(format: "icon%d.jpg", index % 5)
            data.time = nowTime()
            if index == 0 {
                data.unReadCout = 100
            } else if index == 1 {
                data.unReadCout = 28
            }else if index == 2 {
                data.unReadCout = 2
            }
            arr.append(data)
            totalUnReadCount += data.unReadCout
        }
        
        return arr
    }
    

}
