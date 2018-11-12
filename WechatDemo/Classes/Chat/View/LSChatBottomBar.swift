//
//  LSChatBottomBar.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/22.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSChatBottomBar: UIView, UITextViewDelegate {
    
    let margin: CGFloat = 10.0
    let img = UIImage(named:"002")
    let normalimage = UIImage(named:"chatBar_recordBg")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 10)
    let selectImage = UIImage(named:"chatBar_recordSelectedBg")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 10)
    var textViewW: CGFloat = 0.0
    var textViewH: CGFloat = 0.0
    var viewModel: LSChatViewModel?
    var voiceBtn = UIButton(type: .custom)
    var faceBtn = UIButton(type: .custom)
    var plusBtn = UIButton(type: .custom)
    var textView = UITextView()
    var isVoiceState = false
    var voiceRecordManager = LSVoiceRecordManager()
    override var frame: CGRect{
        didSet{
            addTopBorder(color: RGB(r: 121, g: 121, b: 121), borderWidth: 0.5)
            layoutSubviews()
        }
    }
    
    
    init(viewModel: LSChatViewModel?) {
        super.init(frame: CGRect.init())
        self.viewModel = viewModel
        initUI()
    }
    
    lazy var recordBtn: UIButton = {
        
        
        let recordBtn =  UIButton(type: .custom)
        recordBtn.adjustsImageWhenHighlighted = false
        recordBtn.setBackgroundImage(normalimage, for: .normal)
        recordBtn.setTitle("按住 通话", for: .normal)
        recordBtn.setTitleColor(UIColor.darkGray, for: .normal)
        recordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        recordBtn.addTarget(self, action: #selector(self.recordBtnTouchDown(_:)), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(self.recordBtnTouchUpOutside(_:)), for: .touchUpOutside)
        recordBtn.addTarget(self, action: #selector(self.recordBtnTouchUpInside(_:)), for: .touchUpInside)
        recordBtn.addTarget(self, action: #selector(self.recordBtnTouchDragExit(_:)), for: .touchDragExit)
        recordBtn.addTarget(self, action: #selector(self.recordBtnTouchDragEnter(_:)), for: .touchDragEnter)
        return recordBtn
    }()
    
    
    func initUI() {
        
        backgroundColor = bgColor
        
        voiceBtn.setBackgroundImage(UIImage(named:"002"), for: .normal)
        faceBtn.setBackgroundImage(UIImage(named:"009"), for: .normal)
        plusBtn.setBackgroundImage(UIImage(named:"001"), for: .normal)
        addSubview(voiceBtn)
        addSubview(faceBtn)
        addSubview(plusBtn)

        voiceBtn.reactive.controlEvents(.touchUpInside).observe { (signal) in
            print("voiceBtnClick")
            self.voiceBtnClick()
        }
        plusBtn.reactive.controlEvents(.touchUpInside).observe { (signal) in
            print("voiceBtnClick")
        }
        faceBtn.reactive.controlEvents(.touchUpInside).observe { (signal) in
            print("faceBtnClick")
        }
        
        
        textView.returnKeyType = .send
        textView.delegate = self
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        textView.font = LSFontSize16
        textView.backgroundColor = UIColor.white
        textView.enablesReturnKeyAutomatically = true
        addSubview(textView)
        
        
         textViewW = kScreenW - (3 * (img?.size.width)!) - (5 * margin)
         textViewH = (img?.size.height)! + margin * 0.5
         let textViewMaxHeight: CGFloat = 80.0
        textView.reactive.continuousAttributedTextValues.observeValues { (text) in
            if let length = text?.length {
                if length <= 0 {
                    return
                }
            }
            
            let contentTextH  = text?.boundingRect(with: CGSize.init(width: self.textViewW-20, height: CGFloat(Double(MAXFLOAT))),options: NSStringDrawingOptions.usesLineFragmentOrigin ,context: nil).size.height
            if let contentTextH = contentTextH {
                if contentTextH > textViewMaxHeight{
                    self.textViewH = textViewMaxHeight
                } else if contentTextH < (self.img?.size.height)! + self.margin * 0.5 {
                    self.textViewH = (self.img?.size.height)! + self.margin * 0.5
                }
                self.viewModel?.observerBottomBarTextViewIsEditing.send(value: self.textViewH + self.margin)
            }
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        voiceBtn.frame = CGRect(x: margin, y: self.frame.size.height - (margin + (img?.size.height)!), width: (img?.size.width)!, height: (img?.size.height)!)
        faceBtn.frame = CGRect(x: kScreenW - 2 * ((img?.size.width)! + margin), y: self.frame.size.height - (margin + (img?.size.height)!), width: (img?.size.width)!, height: (img?.size.height)!)
        plusBtn.frame = CGRect(x: kScreenW - (img?.size.width)! - margin, y: self.frame.size.height - (margin + (img?.size.height)!), width: (img?.size.width)!, height: (img?.size.height)!)
        textView.frame = CGRect(x: (img?.size.width)! + 2 * margin, y: (self.frame.size.height - textViewH) * 0.5, width: textViewW, height: textViewH)


    }
    
    @objc fileprivate func recordBtnTouchDown(_ button : UIButton) {
        recordButtonState(state: .touchDown)
        viewModel?.observerBottomBarVoiceBtnClickEvent.send(value: .touchDown)
    }
    
    @objc fileprivate func recordBtnTouchUpOutside(_ button : UIButton) {
        recordButtonState(state: .touchUpInside)
        viewModel?.observerBottomBarVoiceBtnClickEvent.send(value: .touchUpOutside)
    }
    
    @objc fileprivate func recordBtnTouchUpInside(_ button : UIButton) {
        recordButtonState(state: .touchUpInside)
        viewModel?.observerBottomBarVoiceBtnClickEvent.send(value: .touchUpInside)
    }
    
    @objc fileprivate func recordBtnTouchDragExit(_ button : UIButton) {
        recordButtonState(state: .touchDragExit)
        viewModel?.observerBottomBarVoiceBtnClickEvent.send(value: .touchDragExit)
    }
    
    @objc fileprivate func recordBtnTouchDragEnter(_ button : UIButton) {
        recordButtonState(state: .touchDragEnter)
        viewModel?.observerBottomBarVoiceBtnClickEvent.send(value: .touchDragEnter)
    }
    
    func recordButtonState(state: RecordBtnEvent){
        
        if state == .touchUpInside || state ==  .touchUpOutside {
            
            recordBtn.setBackgroundImage(normalimage, for: .normal)
            recordBtn.setTitle("按住 通话", for: .normal)
            
        } else if state == .touchDragExit{
            
            recordBtn.setBackgroundImage(selectImage, for: .normal)
            recordBtn.setTitle("松开 取消 ", for: .normal)
            
        } else {
            
            recordBtn.setBackgroundImage(selectImage, for: .normal)
            recordBtn.setTitle("松开 结束 ", for: .normal)
        }
    }
    
    func voiceBtnClick()  {
        
        isVoiceState = !isVoiceState
        
        if isVoiceState {
            voiceBtn.setBackgroundImage(UIImage(named:"003"), for: .normal)
            recordBtn.frame = textView.frame
            addSubview(recordBtn)
            /** 如果给textView 添加多个手势会有手势失效 iOS Touch: Failed to receive system gesture state notification before next touch
             */
            
        } else {
            voiceBtn.setBackgroundImage(UIImage(named:"002"), for: .normal)
            textView.textAlignment = .left
            textView.becomeFirstResponder()
            recordBtn.removeFromSuperview()
        }
        
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isVoiceState {
            return false
        }
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            let inputText = textView.text.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            if inputText.count > 0 {
               viewModel?.observerBottomBarTextViewDidClickSend.send(value: inputText)
                textView.text = nil
                textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
               let alert =  UIAlertView.init(title: "不能发送空白消息", message: nil, delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            
        }
        return true
    }
}
