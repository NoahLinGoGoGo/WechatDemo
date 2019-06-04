//
//  LS.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/5.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

extension UIView {

    func performGraduallyAnimation() {
        
        
        //创建彩虹渐变层
        var  gradientLayer =  CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        
        
        //设置渐变层的颜色
        var rainBowColors:[CGColor] = []
        var hue:CGFloat = 0
        while hue <= 360 {
            let color = UIColor(hue: 1.0*hue/360.0, saturation: 1.0, brightness: 1.0,
                                alpha: 1.0)
            rainBowColors.append(color.cgColor)
            hue += 5
        }
        gradientLayer.colors = rainBowColors
        
        //添加渐变层
        self.layer.addSublayer(gradientLayer)
        
        //创建遮罩层（使用贝塞尔曲线绘制）
        maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn:
            bounds.insetBy(dx: ringWidth/2, dy: ringWidth/2)).cgPath
        maskLayer.strokeColor = UIColor.gray.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = ringWidth
        
        //设置遮罩
        gradientLayer.mask = maskLayer
        
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        //创建动画实现渐变颜色从左上向右下移动的效果
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = duration
        animation.fromValue = fromColors
        animation.toValue = toColors
        //动画完成后是否要移除
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionLinear)
        animation.delegate = self
        //将动画添加到图层中
        gradientLayer.add(animation, forKey: "colors")
    }
    
    
    //将颜色数组中的最后一个元素移到数组的最前面
    func shiftColors(colors:[CGColor]) -> [CGColor] {
        //复制一个数组
        var newColors: [CGColor] = colors.map{($0.copy()!) }
        //获取最后一个元素
        let last: CGColor = newColors.last!
        //将最后一个元素删除
        newColors.removeLast()
        //将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        //返回新的颜色数组
        return newColors
    }
   
}
