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
        contentLabel.font = LSFontSize16
        contentView.addSubview(contentLabel)
    }
    
    
    override func configure(indexpath: IndexPath,  viewModel: LSChatViewModel, array:Array<LSChatCellViewModel>) {
        super.configure(indexpath: indexpath, viewModel: viewModel, array: array)
        
        let attributes = [NSAttributedStringKey.font: LSFontSize16, NSAttributedStringKey.foregroundColor: RGB(r: 51, g: 51, b: 51)] as [NSAttributedStringKey : Any]
        let attributedMessage = NSMutableAttributedString(string: cellViewModel!.textContent, attributes: attributes)
        PPStickerDataManager.sharedInstance()?.replaceEmoji(for: attributedMessage, font: LSFontSize16)
        contentLabel.attributedText = attributedMessage
//        contentLabel.text = cellViewModel?.textContent
    }
    
    
    override func updateSubViewFrame()  {
        super.updateSubViewFrame()
        let attributes = [NSAttributedStringKey.font: LSFontSize16, NSAttributedStringKey.foregroundColor: RGB(r: 51, g: 51, b: 51)] as [NSAttributedStringKey : Any]
        let attributedMessage = NSMutableAttributedString(string: cellViewModel!.textContent, attributes: attributes)
        PPStickerDataManager.sharedInstance()?.replaceEmoji(for: attributedMessage, font: LSFontSize16)
        
        var contentTextH = attributedMessage.boundingRect(with: CGSize.init(width: Double(kScreenW * 0.6), height: Double(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height;
        
        var contentTextW = attributedMessage.boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: Double(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.width;
//        var contentTextH  = (cellViewModel?.textContent.boundingRect(with: CGSize.init(width: Double(kScreenW * 0.6), height: Double(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : LSFontSize16] ,context: nil).size.height)!
//
//        var contentTextW  = cellViewModel?.textContent.boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: Double(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : LSFontSize16] ,context: nil).size.width
        
        
        if contentTextW > kScreenW * 0.7 {
            contentTextW = kScreenW * 0.6
        }
        
        if contentTextH < 30 {
            contentTextH = 30
        }
        
        if cellViewModel!.isFromSelf {
            
            
            contentLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(bgImageView.snp.centerY).offset(-8)
                make.left.equalTo(bgImageView.snp.left).offset(12)
                make.right.equalTo(bgImageView.snp.right).offset(-12)
            })

            bgImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW + 30.0)
                make.height.equalTo(contentTextH + 25.0)
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW + 30.0)
                make.height.equalTo(contentTextH + 25.0)
            }
            
        } else {
            
            
            contentLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(bgImageView.snp.centerY).offset(-8)
                make.left.equalTo(bgImageView.snp.left).offset(16)
                make.right.equalTo(bgImageView.snp.right).offset(-12)
            })
            
            bgImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW + 30.0)
                make.height.equalTo(contentTextH + 25.0)
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.width.equalTo(contentTextW + 30.0)
                make.height.equalTo(contentTextH + 25.0)
            }
        }
    }
    
}
