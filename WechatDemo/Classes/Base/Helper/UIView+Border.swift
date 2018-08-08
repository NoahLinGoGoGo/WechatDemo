//
//  LS.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/26.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

extension UIView {
    
    func addTopBorder(color: UIColor?, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color?.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        layer.addSublayer(border)
    }
    
    func addBottomBorder(color: UIColor?, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color?.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        layer.addSublayer(border)
    }
    
    func addLeftBorder(color: UIColor?, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color?.cgColor
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        layer.addSublayer(border)
    }
    
    func addRightBorder(color: UIColor?, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color?.cgColor
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        layer.addSublayer(border)
    }
    
}
