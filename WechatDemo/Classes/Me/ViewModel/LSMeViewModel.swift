//
//  LSMeViewModel.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/23.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSMeViewModel: LSBaseReqViewModel {

    var dataArray: Array<Array<(String, String, String)>> = Array()
    
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
    
    
    func WebArray() -> Array<Array<(String, String, String)>> {
        
        var arr: Array<Array<(String, String, String)>> = Array()
        for i in 0...3 {
            switch i {
            case 0  :
                var array: Array<(String, String, String)> = Array()
                let item0: (String, String, String) = ("myIcon.jpg","林升起","微信号：Linson0818")
                array.append(item0)
                arr.insert(array, at: i)
                
            case 1 :
                var array: Array<(String, String, String)> = Array()
                let item0: (String, String, String) = ("MoreMyBankCard","钱包","")
                array.append(item0)
                arr.insert(array, at: i)
            case 2 :
                var array: Array<(String, String, String)> = Array()
                let item0: (String, String, String) = ("MoreMyFavorites","收藏","")
                let item1: (String, String, String) = ("MoreMyAlbum","相册","")
                let item2: (String, String, String) = ("MyCardPackageIcon","卡包","")
                let item3: (String, String, String) = ("MoreExpressionShops","表情","")
                array.append(item0)
                array.append(item1)
                array.append(item2)
                array.append(item3)
                arr.insert(array, at: i)
            case 3 :
                var array: Array<(String, String, String)> = Array()
                let item0: (String, String, String) = ("MoreSetting","设置","")
                array.append(item0)
                arr.insert(array, at: i)
                
                
            default:
                return []
            }
            
        }
        return arr
    }
}
