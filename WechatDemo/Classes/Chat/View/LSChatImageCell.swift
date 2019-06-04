//
//  LSChatImageCell.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/20.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import Kingfisher

class LSChatImageCell: LSChatBaseCell {
    
    var contentImageView = UIImageView()
    
    override func addsubViews() {
        super.addsubViews()
        
        contentImageView.layer.cornerRadius = 5.0;
        contentImageView.layer.masksToBounds = true
        contentView.insertSubview(contentImageView, aboveSubview: bgImageView)
    }
    
    
    override  func configure(indexpath: IndexPath, viewModel: LSChatViewModel, array: Array<LSChatCellViewModel>) {
        super.configure(indexpath: indexpath, viewModel: viewModel, array: array)

        let defaultImageH: CGFloat = 140.0
        let defaultImageW: CGFloat = 220.0
        var imageW = defaultImageH * 1.4
        var imageH = defaultImageH

        contentImageView.kf.setImage(with: URL(string:cellViewModel!.imageUrl), placeholder: UIImage(named:"placeholder.png"), options: nil, progressBlock: nil) { (image, error, cache, url) in
            
            imageW = (image?.size.width)!
            imageH = (image?.size.height)!
            
            if (imageW > imageH) {
                
                imageW = imageW / imageH * defaultImageH
                
                if imageW > defaultImageW {
                    imageW = defaultImageW
                }
                imageH = defaultImageH
            }else{
                imageW = imageW / (imageH - 20) * defaultImageH
                imageW = max(imageW, 30)
                imageH = defaultImageH
            }
            
            self.updateContentFrame(imageWidth: imageW, imageHeight: imageH)
            self.clipContentImage()
        }

    }
    
    
    
    func updateContentFrame(imageWidth: CGFloat, imageHeight: CGFloat) {
        
        if cellViewModel!.isFromSelf {
            
            bgImageView.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
                
            })
            
            bgClearBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
                
            })
            
            contentImageView.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)

            })

            
        } else {
            
            bgImageView.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
                
            })
            
            bgClearBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
                
            })
            
            contentImageView.snp.remakeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.top)
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)

            })
        }
                setNeedsLayout()
                layoutIfNeeded()
    }
    
    
    func clipContentImage()  {
        
        let layer = CAShapeLayer()
        layer.frame = bgImageView.bounds
        layer.contents = bgImageView.image?.cgImage
        layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.1, height: 0.1)
        layer.contentsScale = 2
        contentImageView.layer.mask = layer
        contentImageView.layer.frame =  bgImageView.frame
        contentImageView.layer.masksToBounds = true
    }
    
    
}
