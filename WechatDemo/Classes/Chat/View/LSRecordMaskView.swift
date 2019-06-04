//
//  LSTopBottomButton.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/4.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSRecordMaskView : UIView {
    
    var viewModel: LSChatViewModel?
    var topBtn = UIButton(type: .custom)
    var bottomLabel = UILabel()

    
    init() {
        super.init(frame: CGRect.init())
  
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initUI()  {
        
        addSubview(topBtn)
        addSubview(bottomLabel)
        
        backgroundColor = RGBA(r: 150, g: 150, b: 150, a: 0.7)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        topBtn.setBackgroundImage(UIImage(named:"VoiceSearchFeedback"), for: .normal)
        bottomLabel.text = "手指上滑，取消发送"
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 13.0)
        bottomLabel.layer.cornerRadius = 5.0
        bottomLabel.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBtn.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).offset(-20)
            make.size.equalTo(CGSize(width: 150, height: 150))
        })
        
        bottomLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.size.equalTo(CGSize(width: 130, height: 25))
        })
    }
    
}
