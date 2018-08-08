//
//  LSChatTextCell.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/15.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatTextCell: LSChatBaseCell {

     var contentLabel =  UILabel()
    
    
    override func addsubViews() {
        super.addsubViews()
        
        contentLabel.textColor = RGB(r: 51, g: 51, b: 51)
        contentLabel.numberOfLines = 0
        contentLabel.font = titleFontSize
        contentView.addSubview(contentLabel)
        
    }

    
    override func configure(indexpath: IndexPath,  viewModel: LSChatViewModel, array:Array<LSChatCellViewModel>) {
         super.configure(indexpath: indexpath, viewModel: viewModel, array: array)
 
        contentLabel.text = cellViewModel?.textContent

    }
    
    
   override func updateSubViewFrame()  {
     super.updateSubViewFrame()
        
        let contentTextH  = (cellViewModel?.textContent.boundingRect(with: CGSize.init(width: Double(kScreenW * 0.6 + 30.0), height: Double(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : titleFontSize] ,context: nil).size.height)! + 8.0
        
        
        var contentTextW  = cellViewModel?.textContent.boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: Double(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : titleFontSize] ,context: nil).size.width
        
        
        if contentTextW! > kScreenW * 0.7 {
            contentTextW = kScreenW * 0.6
        }
        
        if cellViewModel!.isFromSelf {
            
            
            contentLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(bgImageView.snp.centerY).offset(-8)
                make.left.equalTo(bgImageView.snp.left).offset(16)
                make.right.equalTo(bgImageView.snp.right).offset(-12)
            })
            
            bgImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW! + 30.0)
                make.height.equalTo(contentTextH + 30.0)
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW! + 30.0)
                make.height.equalTo(contentTextH + 30.0)
            }
            
        } else {
            
            
            contentLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(bgImageView.snp.centerY).offset(-8)
                make.left.equalTo(bgImageView.snp.left).offset(16)
                make.right.equalTo(bgImageView.snp.right).offset(-12)
            })
            
            bgImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW! + 30.0)
                make.height.equalTo(contentTextH + 30.0)
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW! + 30.0)
                make.height.equalTo(contentTextH + 30.0)
            }
        }
    }
    
}
