//
//  LSTopMiniProgramCell.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/31.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSTopMiniProgramCell: UICollectionViewCell {
    
    
    var imageView: UIImageView!
    var titleLabel: UILabel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        /// 添加观察者,在写swift的KVO的过程中，被监听的属性必须用“dynamic”修饰，否则监听的代理方法不走
//        addObserver(self, forKeyPath: "frame", options: [.new], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        
        imageView = UIImageView()
        imageView.layer.cornerRadius = (frame.size.width - 10.0) * 0.5
        imageView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        titleLabel.textColor = bgColor
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let frame: CGRect = self.bounds
        let imgx: CGFloat = 5.0
        let imgy = imgx
        let frameWidth: CGFloat = frame.size.width
        let imgWidth: CGFloat = frameWidth - (imgx * 2.0)
        
        self.imageView.frame = CGRect(x: imgx, y: imgy, width: imgWidth, height: imgWidth)
        
        self.titleLabel.frame = CGRect(x: 0, y:imgy+frameWidth , width: frameWidth, height: 20)
    }

}
