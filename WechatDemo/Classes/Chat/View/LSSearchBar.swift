//
//  LSSearchBar.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/14.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSSearchBar: UISearchBar,UITextFieldDelegate {
    
    let searchIconW: CGFloat = 20.0
    let iconSpacing: CGFloat = 10.0
    let placeHolderFont: CGFloat = 15.0
    let iOS11Version: Double = 11.0
    
     init() {
        super.init(frame: CGRect.init())
        
        for (_,subView) in (subviews.last?.subviews.enumerated())! {
            if subView is UITextField {
                
                
                if iosVersion! >= iOS11Version {
                    setPositionAdjustment(UIOffsetMake(subView.frame.size.width * 0.5, 0), for: .search)
                }
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var placeholderWidth:CGFloat {
        get {
            let width = placeholder?.boundingRect(with: CGSize.init(width:CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: placeHolderFont)] ,context: nil).size.width
            return width! + iconSpacing + searchIconW
        }
    }
    
    
    
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        if (self.delegate?.responds(to: Selector(("searchBarShouldEndEditing"))))! {
            self.delegate?.searchBarShouldEndEditing!(self)
        }
        
        if iosVersion! >= iOS11Version {
            setPositionAdjustment(UIOffsetMake(textField.frame.size.width * 0.5, 0), for: .search)
        }
        
        return true
    }
    
    
    
    
    
    
//    // 结束编辑的时候设置为居中
//    - (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
//    [self.delegate searchBarShouldEndEditing:self];
//    }
//    if (@available(iOS 11.0, *)) {
//    [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
//    }
//    return YES;
//    }
//
//    // 计算placeholder、icon、icon和placeholder间距的总宽度
//    - (CGFloat)placeholderWidth {
//    if (!_placeholderWidth) {
//    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
//    _placeholderWidth = size.width + iconSpacing + searchIconW;
//    }
//    return _placeholderWidth;
//    }

}
