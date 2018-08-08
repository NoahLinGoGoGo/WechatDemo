//
//  LSChatVoiceCell.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/4.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatVoiceCell: LSChatBaseCell {
    
    var timer: Timer?
    var voiceMsgSecondLength = 0
    var lengthLabel =  UILabel()
    var voiceImageView = UIImageView()
    var animation: CABasicAnimation {
        get {
            let startColor = RGB(r: 222, g: 222, b: 222)
            let tintColor = RGB(r: 46, g: 170, b: 254)
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.fromValue = startColor.cgColor
            animation.toValue = tintColor.cgColor
            animation.duration = 1.5
            animation.repeatCount = MAXFLOAT
            return animation
        }
    }
    
    
    override func addsubViews() {
        super.addsubViews()
        
        lengthLabel.textColor = RGB(r: 101, g: 101, b: 101)
        lengthLabel.font = titleFontSize
        contentView.addSubview(lengthLabel)
        contentView.addSubview(voiceImageView)
    }
    
    
    override func configure(indexpath: IndexPath,  viewModel: LSChatViewModel, array:Array<LSChatCellViewModel>) {
        super.configure(indexpath: indexpath, viewModel: viewModel, array: array)
        
        lengthLabel.text = String(format:"%d",(cellViewModel?.voiceLength)!) + "\""
        if cellViewModel!.isFromSelf {
            voiceImageView.image = UIImage(named:"SenderVoiceNodePlaying")
        } else {
           voiceImageView.image = UIImage(named:"ReceiverVoiceNodePlaying")
        }
        
        updateContentFrame()
        clipBGClearBtn()
       
        if indexpath.row + 1 == array.count {
             setAnimation()
        }
       
        
        self.viewModel?.bgClearBtnClickSignal.observeValues({ (viewModel) in
            
            if viewModel.id == self.cellViewModel?.id {
                self.stopTimer()
                self.startTimer()
            } else {
                self.stopTimer()
                self.stopVoiceImageAnimation()
            }
        })
        
    }
    
    
    func updateContentFrame()  {
        super.updateSubViewFrame()
        
        let defalutWidth = 66.0
        let maxWidth = 180.0
        var voiceWidth = 0.0
        if cellViewModel!.voiceLength >= 60 {
            voiceWidth = maxWidth
        } else {
            
            let r = 1.0 * Double(cellViewModel!.voiceLength) / 60.0
            let width = r * (maxWidth - defalutWidth)
            voiceWidth = defalutWidth + width
        }
        
        
        if cellViewModel!.isFromSelf {
            
            bgImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.bottom.equalTo(iconImageView.snp.bottom).offset(15)
                make.width.equalTo(voiceWidth)
                
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(iconImageView.snp.left).offset(-10)
                make.top.equalTo(iconImageView.snp.top)
                make.bottom.equalTo(iconImageView.snp.bottom).offset(15)
                make.width.equalTo(voiceWidth)
                
            }
            
            voiceImageView.snp.remakeConstraints({ (make) in
                make.right.equalTo(bgImageView.snp.right).offset(-10)
                make.centerY.equalTo(iconImageView.snp.centerY)
                make.size.equalTo(CGSize(width: 25, height: 30))
            })
            
            lengthLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconImageView.snp.centerY)
                make.right.equalTo(bgImageView.snp.left).offset(-5)
            })
            
        } else {
            
            bgImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.bottom.equalTo(iconImageView.snp.bottom).offset(15)
                make.width.equalTo(voiceWidth)
            }
            
            bgClearBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10)
                make.top.equalTo(iconImageView.snp.top)
                make.bottom.equalTo(iconImageView.snp.bottom).offset(15)
                make.width.equalTo(voiceWidth)
            }
            
            voiceImageView.snp.remakeConstraints({ (make) in
                make.right.equalTo(bgImageView.snp.left).offset(10)
                make.centerY.equalTo(iconImageView.snp.centerY)
                make.size.equalTo(CGSize(width: 25, height: 30))
            })
            
            lengthLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconImageView.snp.centerY)
                make.left.equalTo(bgImageView.snp.right).offset(5)
            })
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    
    func setAnimation()  {
        if cellViewModel?.voiceLength == 0 {
            lengthLabel.isHidden = true
            voiceImageView.isHidden = true
            StartBGClearBtnAnimation()
        } else {
            lengthLabel.isHidden = false
            voiceImageView.isHidden = false
            StopBGClearBtnAnimation()
        }
    }
    
    
    func clipBGClearBtn()  {
        
        let layer = CAShapeLayer()
        layer.frame = bgImageView.bounds
        layer.contents = bgImageView.image?.cgImage
        layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.1, height: 0.1)
        layer.contentsScale = 2
        bgClearBtn.layer.mask = layer
        bgClearBtn.layer.frame =  bgImageView.frame
        bgClearBtn.layer.masksToBounds = true
    }
    
    func StartBGClearBtnAnimation() {
        
        bgClearBtn.layer.add(animation, forKey: nil)
        bgClearBtn.layer.backgroundColor = tintColor.cgColor
    }
    
    
    func StopBGClearBtnAnimation() {
        bgClearBtn.layer.removeAllAnimations()
        bgClearBtn.backgroundColor = UIColor.clear
    }
    
    
    //MARK:- Timer
    func startTimer()  {
        
        startVoiceImageAnimation()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.voiceLength), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
        
    }
    
    
    func stopTimer()  {
        timer?.invalidate()
        timer = nil
        voiceMsgSecondLength = 0
    }
    
    @objc func voiceLength()  {
        
        voiceMsgSecondLength = voiceMsgSecondLength  + 1
        if voiceMsgSecondLength == cellViewModel?.voiceLength {
            stopTimer()
            stopVoiceImageAnimation()
        }
    }
    
    
    func startVoiceImageAnimation()  {
        
        var imageViewArray = Array<UIImage>()
        
        if !cellViewModel!.isFromSelf {
            for i in 0...3 {
                imageViewArray.append(UIImage(named: String(format: "chat_receiver_audio_playing00%d", i))!)
            }
        } else {
            for i in 0...3 {
                imageViewArray.append(UIImage(named: String(format: "chat_sender_audio_playing_00%d", i))!)
            }
        }
        
        voiceImageView.animationImages = imageViewArray
        voiceImageView.animationRepeatCount = 0
        voiceImageView.animationDuration = 1.0
        voiceImageView.startAnimating()
        
    }
    
    func stopVoiceImageAnimation()  {
        voiceImageView.stopAnimating()
    }

    
}
