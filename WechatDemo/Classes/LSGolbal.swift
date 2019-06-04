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
public let RGB51 = RGB(r: 51, g: 51, b: 51)

public let LS_IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone ? true : false

public let Height_StatusBar: CGFloat  = UIApplication.shared.statusBarFrame.size.height
public let Height_NavBarAndStatusBar: CGFloat = LS_IS_IPHONE_X() ? 88.0 : 64.0
public let Height_TabBar: CGFloat  = LS_IS_IPHONE_X() ? 83.0 : 49.0


let chatListClickNotification = "chatListClickNotification"




let miniProgramDefaultH: CGFloat = 200.0

public let LSFontSize16 = UIFont.systemFont(ofSize: 16.0)

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

public func LS_IS_IPHONE_X() -> Bool {

    let w = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 375
    let h = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 812
    if iosVersion >= 11.0 && LS_IS_IPHONE && w && h {
        return true
    } else {
        return false
    }
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


