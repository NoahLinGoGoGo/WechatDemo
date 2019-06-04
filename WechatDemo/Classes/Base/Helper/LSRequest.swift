//
//  LSRequest.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/29.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import Alamofire


class LSRequest: NSObject {
    

     public func GET(url: String, paras: Parameters?, success: @escaping (LSRequest,String?) -> Void, failure: @escaping (LSRequest,Error) -> Void)  {
        let header: HTTPHeaders = ["Accept":"application/json"]
        Alamofire.request(url, parameters: paras, headers: header).responseData { (response)in
            
            switch response.result {
            case .success:
//                print("success\(response.result.value ?? Data())")
                if let data = response.result.value {
                  let responseStr = String.init(data: data, encoding: String.Encoding.utf8)
                    success(self, responseStr)
                }
                
            case .failure:
//                print("failure\(response.error ?? "nil" as! Error)")
                if let error = response.error {
                     failure(self,error)
                }
                
            }
            
        }
    }
    
    
     public func POST(url: String, paras: Parameters?, success: @escaping (LSRequest,String?) -> Void, failure: @escaping (LSRequest,Error) -> Void)  {
//        let header: HTTPHeaders = ["Accept":"application/json"]
        Alamofire.request(url, method: .post, parameters: paras).responseData { (response)in
            
            switch response.result {
            case .success:
//                print("success\(response.result.value ?? Data())")
                if let data = response.result.value {
                    let responseStr = String.init(data: data, encoding: String.Encoding.utf8)
                    success(self, responseStr)
                }
                
            case .failure:
//                print("failure\(response.error ?? "nil" as! Error)")
                if let error = response.error {
                    failure(self,error)
                }
                
            }
        }
    }
    
    
    public func dataToDictionary(data:Data) ->Dictionary<String,Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String,Any>
            return dic
            
        } catch _ {
            print("dataToDictionary失败")
            return nil
        }
    }
    
    
}
