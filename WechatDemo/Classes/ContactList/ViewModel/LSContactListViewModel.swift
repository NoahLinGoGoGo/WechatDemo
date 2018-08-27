//
//  LSContactListViewModel.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/22.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result


class LSContactListViewModel: LSBaseReqViewModel {

    var dataArray: Array<LSContactListCellViewModel> = Array()
    
    let names = ["赵四","钱三强","孙二娘","李隆基","周周","iOS阿东","吴福来","郑成功","王麻子","冯一冷","唐朝","黄迪","林超","林郑月娥","—&—","欧阳娜娜",]
    
        
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
    
    
    func WebArray() -> Array<LSContactListCellViewModel> {
        
        var arr: Array<LSContactListCellViewModel> = []
        for (index,element) in names.enumerated() {
            
            let data =  LSContactListCellViewModel()
            data.name = element
            data.icon = String.init(format: "icon%d.jpg", index % 5)
            arr.append(data)
        }
        
        return arr
    }
}
