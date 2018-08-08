//
//  LSPulbic.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import Foundation
import UIKit

public let Host = "https://www.baidu.com"

public let kScreenW  = UIScreen.main.bounds.size.width
public let kScreenH  = UIScreen.main.bounds.size.height
public let iosVersion = (UIDevice.current.systemVersion as NSString).doubleValue
public let bgColor = RGB(r: 228, g: 228, b: 228)


let chatListClickNotification = "chatListClickNotification"



public let titleFontSize = UIFont.systemFont(ofSize: 16.0)

public func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

public func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}

public func randomObject(array: Array<String>) -> String {
    
    let Index: Int = Int(arc4random_uniform(UInt32(array.count)))
    return array[Index]
}

public func printAddress<T: AnyObject>(o: T) {
    print(String.init(format: "%018p", unsafeBitCast(o, to: Int.self)))
}


// 根据颜色生成图片
func createImageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let myImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return myImage!
}


