//
//  LS.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/9/17.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

extension UITabBar {
    //让图片和文字在iOS11 ipad下仍然保持上下排列
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}
