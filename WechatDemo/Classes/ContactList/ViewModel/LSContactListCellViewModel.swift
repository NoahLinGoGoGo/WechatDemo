//
//  LSContactListCellViewModel.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/22.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSContactListCellViewModel: NSObject {
    var icon: String = ""
    @objc dynamic var name: String  = ""   // KVO & KVC 必须使用 @objc dynamic
}
