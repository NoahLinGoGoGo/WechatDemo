//
//  LSBaseReqViewModel.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/2.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSBaseReqViewModel: NSObject {

    var request = LSRequest()
    var loadDataAction: Action<(), Any, NoError>?
    
    
    override init() {
        super.init()
       
        loadDataAction = Action.init(execute: getChatArray)
    }
    
    
    func loadServerData()  {
        loadDataAction?.apply().start()
    }
    
    
    func getChatArray() -> SignalProducer<Any, NoError> {
        return SignalProducer<Any, NoError>.init { (observer, _) in
            
        }
    }
    
    
}
