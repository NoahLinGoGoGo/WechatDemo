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

public enum LSKeyboardType {
    case none
    case system
    case sticker
}

class LSChatBottomBar: UIView, UITextViewDelegate, PPStickerKeyboardDelegate {
    
    //MARK:- Property
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
    var keyboardType = LSKeyboardType.system {
        willSet {
            if newValue == .system {
                textView.inputView = nil;
                textView.reloadInputViews()
                textView.becomeFirstResponder()
            }
        }
    }
    lazy var stickerKeyboard: PPStickerKeyboard = {
        let stickerKeyboard = PPStickerKeyboard()
        stickerKeyboard.frame = CGRect(x: 0, y: 0, width:self.bounds.size.width , height: stickerKeyboard.heightThatFits())
        stickerKeyboard.delegate = self as? PPStickerKeyboardDelegate
        return stickerKeyboard
    }()
    
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
    
    override var frame: CGRect{
        didSet{
            addTopBorder(color: RGB(r: 121, g: 121, b: 121), borderWidth: 0.5)
            layoutSubviews()
        }
    }
    
    //MARK:- LIfe Cycle
    init(viewModel: LSChatViewModel?) {
        super.init(frame: CGRect.init())
        self.viewModel = viewModel
        initUI()
        bindData()
    }
    
    
    
    
    func bindData() {
        viewModel?.bottomBarTextViewDidClickSendSignal.observeValues({ (inputText) in
            self.textViewH = (self.img?.size.height)! + self.margin * 0.5
            self.textView.frame.size.height = self.textViewH
        })
    }
    
    
    func changeKeyboard(type: LSKeyboardType)  {
        textView.resignFirstResponder()
        if self.keyboardType == type {
            return
        }
        switch type {
        case .none:
            faceBtn.setBackgroundImage(UIImage(named:"009"), for: .normal)
            textView.inputView = nil;
        case .system:
            faceBtn.setBackgroundImage(UIImage(named:"009"), for: .normal)
            textView.inputView = nil;
            textView.reloadInputViews()
            textView.becomeFirstResponder()
            
        case .sticker:
            
            faceBtn.setBackgroundImage(UIImage(named:"003"), for: .normal)
            textView.inputView = stickerKeyboard;
            textView.reloadInputViews()
            textView.becomeFirstResponder()
        }
        keyboardType = type
    }
    
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
            self.changeKeyboard(type: (self.keyboardType == .system ? .sticker : .system))
        }
        
        
        textView.returnKeyType = .send
        textView.delegate = self
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        textView.font = LSFontSize16
        textView.backgroundColor = UIColor.white
        textView.enablesReturnKeyAutomatically = true
        textView.showsVerticalScrollIndicator = false
        addSubview(textView)
        
        
        textViewW = kScreenW - (3 * (img?.size.width)!) - (5 * margin)
        textViewH = (img?.size.height)! + margin * 0.5
        textView.reactive.continuousAttributedTextValues.observeValues { (text) in
            if let length = text?.length {
                if length <= 0 {
                    return
                }
            }
            
            self.sendBottomBarTextViewIsEditingSignal(text: text?.string)
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
        
        // 暂时没有开发，先隐藏
        plusBtn.isHidden = true
        
    }
    
    //MARK:- 录音按钮相关
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
            textView.resignFirstResponder()
            
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if keyboardType == .sticker {
            textView.inputView = nil;
            textView.reloadInputViews()
            textView.becomeFirstResponder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            let inputText = textView.text.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
            if inputText.count > 0 {
                viewModel?.observerBottomBarTextViewDidClickSend.send(value: textView.text)
                textView.text = nil
                textView.resignFirstResponder()
            } else {
                textView.resignFirstResponder()
                let alert =  UIAlertView.init(title: "不能发送空白消息", message: nil, delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            
        }
        return true
    }
    

    //MARK:- PPStickerKeyboardDelegate
    func stickerKeyboardDidClickDeleteButton(_ stickerKeyboard: PPStickerKeyboard!) {
//        print("stickerKeyboardDidClickDeleteButton")
        var textViewText: String = textView.text
        if 0 >= textViewText.count {
            return
        }
        let selectedRange = textView.selectedRange
        let originSelectRangeCount = textViewText.count
        
        if selectedRange.length > 0 {
            let startIndex = String.Index(encodedOffset: textView.selectedRange.location)
            let selectedLength = textView.selectedRange.length - 1
            let  endIndex = textViewText.index(startIndex, offsetBy: selectedLength)
            let  range = startIndex...endIndex
            textViewText.removeSubrange(range)
            textView.text = textViewText
            textView.selectedRange = NSRange(location: selectedRange.location, length: 0)
        } else {
            
            /**
             截取某一段字符串
             
             let index2 = str.index(str.endIndex, offsetBy: -10)
             let sub4 = str[index2..<str.endIndex]
             
             
             //字符换的删除
             str.remove(at: str.index(before: str.endIndex))
             print("删除.以后的字符串+\(str)")
             
             //删除范围的字符串
             let  startIndex = str.startIndex
             let  endIndex = str.index(startIndex, offsetBy: 5)
             let  range = startIndex...endIndex
             str.removeSubrange(range)
             print("删除范围后的+\(str)")
             
             */
            // 截取某一个范围的字符串
            if 0 == textView.selectedRange.location {
                return
            }
            let startIndex = textViewText.index(textViewText.startIndex, offsetBy: textView.selectedRange.location - 1)
            let endIndex = textViewText.index(startIndex, offsetBy: 0)
            let lastChar = textViewText[startIndex...endIndex]
            
            let subTextViewText = String(textViewText.prefix(textView.selectedRange.location))
            if lastChar == "]" {
                var startOccurranceOfFace = subTextViewText.positionOf(sub: "[", backwards: true)
                if -1 == startOccurranceOfFace {
                    startOccurranceOfFace = 0
                }
                let startIndex = String.Index(encodedOffset: startOccurranceOfFace)
               
                let range = startIndex...endIndex
                 textViewText.removeSubrange(range)
            } else {
                textViewText.remove(at: startIndex)
            }
             textView.text = textViewText
            let actualDelectedLength = originSelectRangeCount - textViewText.count
            if selectedRange.location >= actualDelectedLength  {
                textView.selectedRange = NSRange(location: selectedRange.location - actualDelectedLength, length: 0)
            }
        }
        
        self.sendBottomBarTextViewIsEditingSignal(text: textViewText)
        
    }
    
    func stickerKeyboardDidClickSendButton(_ stickerKeyboard: PPStickerKeyboard!) {
//        print("stickerKeyboardDidClickSendButton")
         let inputText = textView.text.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        if  0 >= inputText.count {
            textView.resignFirstResponder()
            let alert =  UIAlertView.init(title: "不能发送空白消息", message: nil, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        viewModel?.observerBottomBarTextViewDidClickSend.send(value: textView.text)
        textView.text = nil
        textView.resignFirstResponder()
    }
    
    func stickerKeyboard(_ stickerKeyboard: PPStickerKeyboard!, didClick emoji: PPEmoji!) {
        print("stickerKeyboard :\((emoji.imageName,emoji.emojiDescription))");
        let emojiStr: String = "[" + emoji.emojiDescription + "]"
        var textViewText: String = textView.text
        let  startIndex = String.Index(encodedOffset: textView.selectedRange.location)
        var selectedLength = textView.selectedRange.length
        if selectedLength > 0 {
            selectedLength = selectedLength - 1
            let  endIndex = textViewText.index(startIndex, offsetBy: selectedLength)
            let  range = startIndex...endIndex
            // 替换某一范围字符串
            textViewText.replaceSubrange(range, with: emojiStr)
        } else {
            // 在某一个下标处插入字符串
            textViewText.insert(contentsOf:emojiStr, at: startIndex)
        }
        textView.text = textViewText
        textView.selectedRange = NSRange(location: startIndex.encodedOffset + emojiStr.count, length: 0);
        self.sendBottomBarTextViewIsEditingSignal(text: textViewText)
    }
    
    
    //MARK:- update viewmodel signal
    func sendBottomBarTextViewIsEditingSignal(text: String?) {
        let contentTextH  = text?.boundingRect(with: CGSize.init(width: self.textViewW-20, height: CGFloat(Double(MAXFLOAT))),options: NSStringDrawingOptions.usesLineFragmentOrigin ,context: nil).size.height
        let textViewMaxHeight: CGFloat = 80.0
        if let contentTextH = contentTextH {
            if contentTextH < (self.img?.size.height)! + self.margin * 0.5{
                self.textViewH = (self.img?.size.height)! + self.margin * 0.5
            } else if contentTextH > textViewMaxHeight {
                self.textViewH = textViewMaxHeight
            } else {
                self.textViewH = contentTextH
            }
        }
        self.viewModel?.observerBottomBarTextViewIsEditing.send(value: self.textViewH)
        self.textView.frame.size.height = self.textViewH
    }
}
