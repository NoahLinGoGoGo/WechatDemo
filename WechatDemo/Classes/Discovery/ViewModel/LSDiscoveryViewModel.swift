//
//  LSDiscoveryViewModel.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/23.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class LSDiscoveryViewModel: LSBaseReqViewModel {

    var dataArray: Array<Array<(String, String)>> = Array()
    
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
    
    
    func WebArray() -> Array<Array<(String, String)>> {
        
        var arr: Array<Array<(String, String)>> = Array()
        for i in 0...3 {
            switch i {
            case 0  :
                var array: Array<(String, String)> = Array()
                let item0: (String, String) = ("ff_IconShowAlbum","朋友圈")
                array.append(item0)
                arr.insert(array, at: i)
               
            case 1 :
                var array: Array<(String, String)> = Array()
                let item0: (String, String) = ("ff_IconQRCode","扫一扫")
                let item1: (String, String) = ("ff_IconShake","摇一摇")
                array.append(item0)
                array.append(item1)
                arr.insert(array, at: i)
            case 2 :
                var array: Array<(String, String)> = Array()
                let item0: (String, String) = ("ff_IconBrowse1","看一看")
                let item1: (String, String) = ("ff_IconSearch1","搜一搜")
                array.append(item0)
                array.append(item1)
                arr.insert(array, at: i)
            case 3 :
                var array: Array<(String, String)> = Array()
                let item0: (String, String) = ("MoreWeApp","小程序")
                array.append(item0)
                arr.insert(array, at: i)
           
            
            default:
                return []
            }
        
        }
        return arr
    }
}
