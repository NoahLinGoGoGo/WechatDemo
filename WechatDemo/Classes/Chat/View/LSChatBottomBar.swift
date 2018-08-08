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

class LSChatBottomBar: UIView, UITextFieldDelegate {
    
    
    var viewModel: LSChatViewModel?
    var voiceBtn = UIButton(type: .custom)
    var faceBtn = UIButton(type: .custom)
    var plusBtn = UIButton(type: .custom)
    var textField = UITextField()
    var isVoiceState = false
    let normalimage = UIImage(named:"chatBar_recordBg")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 10)
    let selectImage = UIImage(named:"chatBar_recordSelectedBg")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 10)
    
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
        
        
        let margin: CGFloat = 5.0
        let img = UIImage(named:"002")
        addButton(button: voiceBtn, image: UIImage(named:"002"),buttonX: margin)
        addButton(button: plusBtn, image: UIImage(named:"001"),buttonX: kScreenW - (img?.size.width)! - margin)
        addButton(button: faceBtn, image: UIImage(named:"009"),buttonX: kScreenW - 2 * ((img?.size.width)! + margin))
        
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
        
        
        let textFieldW = kScreenW - (3 * (img?.size.width)!) - (5 * margin)
        textField.frame = CGRect(x: (img?.size.width)! + 2 * margin, y: margin * 1.5 , width: textFieldW, height: (img?.size.height)! + margin)
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.delegate = self
        textField.backgroundColor = UIColor.white
        addSubview(textField)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override var frame: CGRect{
        didSet{
            addTopBorder(color: RGB(r: 121, g: 121, b: 121), borderWidth: 0.5)
        }
    }
    
    func addButton(button: UIButton, image: UIImage?, buttonX: CGFloat)  {
        let margin: CGFloat = 10.0
        let img = UIImage(named:"002")
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: buttonX, y: margin, width: (img?.size.width)!, height: (img?.size.height)!)
        addSubview(button)
        
    }
    
    
    @objc fileprivate func recordBtnTouchDown(_ button : UIButton) {
        recordButtonState(state: .touchDown)
        viewModel?.observerEvent.send(value: .touchDown)
    }
    
    @objc fileprivate func recordBtnTouchUpOutside(_ button : UIButton) {
        recordButtonState(state: .touchUpInside)
        viewModel?.observerEvent.send(value: .touchUpOutside)
    }
    
    @objc fileprivate func recordBtnTouchUpInside(_ button : UIButton) {
        recordButtonState(state: .touchUpInside)
        viewModel?.observerEvent.send(value: .touchUpInside)
    }
    
    @objc fileprivate func recordBtnTouchDragExit(_ button : UIButton) {
        recordButtonState(state: .touchDragExit)
        viewModel?.observerEvent.send(value: .touchDragExit)
    }
    
    @objc fileprivate func recordBtnTouchDragEnter(_ button : UIButton) {
        recordButtonState(state: .touchDragEnter)
        viewModel?.observerEvent.send(value: .touchDragEnter)
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
            recordBtn.frame = textField.frame
            addSubview(recordBtn)
            /** 如果给textField 添加多个手势会有手势失效 iOS Touch: Failed to receive system gesture state notification before next touch
             let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapClick(_:)))
             let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
             */
            
        } else {
            voiceBtn.setBackgroundImage(UIImage(named:"002"), for: .normal)
            textField.textAlignment = .left
            textField.becomeFirstResponder()
            recordBtn.removeFromSuperview()
        }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if isVoiceState {
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        return true
    }
    
    
    
    
    
}
