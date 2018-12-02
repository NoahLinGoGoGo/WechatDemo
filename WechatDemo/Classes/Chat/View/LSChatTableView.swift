//
//  LSChatTableView.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/15.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Toast_Swift

class LSChatTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
     //MARK:- Property
    var viewModel: LSChatViewModel?
    var dataArray: Array<LSChatCellViewModel>?
    var RowHeightArray: Array<CGFloat> = Array()
    var recordMaskView =  LSRecordMaskView()
    var timer: Timer?
    var voiceRecordManager = LSVoiceRecordManager()
    var voiceMsgSecondLength = 0
    var voiceViewModelId: String?
    
    
    //MARK:- Life Cycle Function
    init(viewModel: LSChatViewModel?) {
        super.init(frame: CGRect(), style: .plain)
        self.viewModel = viewModel
        viewModel?.loadServerData()
        initTableView()
        bindData()
    
    }
    
    
    func bindData() {
        
        viewModel?.loadDataAction?.events.observe({ (event) in
            
            self.dataArray = self.viewModel?.dataArray
            self.caculateRowHeight()
            self.reloadData()
        })
        
        viewModel?.bottomBarVoiceBtnClickSignal.observeValues { (event) in
            
            
            if event == .touchDown {
                // 开始录音
                self.voiceViewModelId = String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
                self.voiceRecordManager.beginRecord(path: self.voiceViewModelId!)
                self.startTimer()
                
                self.recordMaskView.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
                self.recordMaskView.center = CGPoint(x: kScreenW * 0.5, y: kScreenH * 0.5)
                self.recordMaskView.bottomLabel.backgroundColor = UIColor.clear
                UIApplication.shared.keyWindow?.addSubview(self.recordMaskView)
                
                
            } else if event == .touchUpInside  {
                // 结束录音
                self.voiceRecordManager.stopRecord(path: self.voiceViewModelId!)
                self.stopTimer()
                self.recordMaskView.removeFromSuperview()
                if self.voiceMsgSecondLength < 1 {
                    print("录音时间太短")
                    self.makeToast("录音时间太短", position: .center)
                    self.deleteOneCellData()
                    return
                }
                self.updateOneCellData()
               
            } else if event ==  .touchUpOutside{
                // 取消录音
                self.voiceRecordManager.stopRecord(path: self.voiceViewModelId!)
                self.stopTimer()
                self.recordMaskView.removeFromSuperview()
                self.deleteOneCellData()
                
            }else if event == .touchDragExit{
                // 取消录音
                self.recordMaskView.bottomLabel.backgroundColor = UIColor.red
                
            }else if event == .touchDragEnter{
                //  继续录音
                self.recordMaskView.bottomLabel.backgroundColor = UIColor.clear
                
            }
            
        }
        
        viewModel?.bottomBarBgClearCoverBtnClickSignal.observeValues({ (cellViewModel) in
            
            if cellViewModel.msgType == .voiceMsg {
                self.voiceRecordManager.play(path: cellViewModel.id!)
            }
        })
        
        
        viewModel?.bottomBarTextViewDidClickSendSignal.observeValues({ (inputText) in
            let textViewModel =  LSChatCellViewModel(msgType: .textMsg, isFromSelf: true)
            textViewModel.textContent = inputText
            self.dataArray?.append(textViewModel)
            self.caculateRowHeight()
            self.reloadData()
            self.scrollsToBottomAnimated()
        })
        
    }
    
    
    func initTableView() {
        backgroundColor = bgColor
        dataSource = self
        delegate = self
        separatorStyle = .none
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- UIScrollView UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = dataArray?.count {
//            for (index, viewModel) in dataArray!.enumerated() {
//                if index > 6 {
//                    print(index,viewModel.id,viewModel.voiceLength)
//                }
//                
//            }
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgType = dataArray?[indexPath.row].msgType
        
        if msgType == .textMsg {
            let identifier = "LSChatTextCell"
            var cell: LSChatTextCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSChatTextCell
            if cell == nil {
                cell = LSChatTextCell.init(style: .default, reuseIdentifier: identifier)
            }
            
            cell?.configure(indexpath: indexPath, viewModel: viewModel!, array: dataArray!)
            
            return cell!
            
        } else if msgType == .imageMsg {
            
            let identifier = "LSChatImageCell"
            var cell: LSChatImageCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSChatImageCell
            if cell == nil {
                cell = LSChatImageCell.init(style: .default, reuseIdentifier: identifier)
                
            }
            
            cell?.configure(indexpath: indexPath, viewModel: viewModel!, array: dataArray!)
            return cell!
            
        } else if msgType == .voiceMsg {
            
            let identifier = "LSChatVoiceCell"
            var cell: LSChatVoiceCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSChatVoiceCell
            if cell == nil {
                cell = LSChatVoiceCell.init(style: .default, reuseIdentifier: identifier)
                
            }
            
            cell?.configure(indexpath: indexPath, viewModel: viewModel!, array: dataArray!)
            return cell!
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if RowHeightArray.count > indexPath.row {
            return RowHeightArray[indexPath.row]
        }
        return 0
    }
        
     //MARK:- Private
    func caculateRowHeight() {
        let cellMargin: CGFloat = 20.0
        RowHeightArray.removeAll()
        for chatViewModel in dataArray! {
            if chatViewModel.msgType == .textMsg {
                
                var contentTextHeight  = chatViewModel.textContent.boundingRect(with: CGSize.init(width: Double(kScreenW * 0.6), height: Double(MAXFLOAT)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : LSFontSize16] ,context: nil).size.height 

                if contentTextHeight < 40 {
                    contentTextHeight = 40
                }
                RowHeightArray.append(contentTextHeight + cellMargin * 1.4)
                
            } else if chatViewModel.msgType == .imageMsg {
                let defaultImageH: CGFloat = 140.0
                RowHeightArray.append(defaultImageH + cellMargin * 0.5)
            }
            
        }
        
    }
    
    // 默认滚动到最后一条消息
    func scrollsToBottomAnimated() {
        
        UIView.animate(withDuration: 0.5) {
            if let count = self.dataArray?.count {
                self.scrollToRow(at: IndexPath.init(row: count - 1, section: 0), at: .bottom, animated: false)
            }
            
        }
    }
    
    
    //MARK:- Timer
    func startTimer()  {
        voiceMsgSecondLength = 0
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.voiceLength), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
     
    }
    

    func stopTimer()  {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func voiceLength()  {
        if voiceMsgSecondLength >= 50 {
            print("语音消息最长60s,10秒开始倒计时")
           self.recordMaskView.topBtn.setBackgroundImage(nil, for: .normal)
            self.recordMaskView.topBtn.setImage(nil, for: .normal)
            self.recordMaskView.topBtn.setTitle(String(format: "%d", 60 - voiceMsgSecondLength), for: .normal)
            self.recordMaskView.topBtn.titleLabel?.font = UIFont.systemFont(ofSize: 34.0)
            if voiceMsgSecondLength == 60 {
                self.voiceRecordManager.stopRecord(path: self.voiceViewModelId!)
                self.stopTimer()
                self.recordMaskView.removeFromSuperview()
                self.updateOneCellData()
                return
            }
        }
        voiceMsgSecondLength = voiceMsgSecondLength  + 1
        if voiceMsgSecondLength == 1 {
            addOneCellData()
        }
//        print("voiceMsgSecondLength:\(voiceMsgSecondLength)")
    }
    
    
    //MARK:- 录音数据处理
    func addOneCellData()  {
        let voiceViewModel =  LSChatCellViewModel(msgType: .voiceMsg, isFromSelf: true)
        voiceViewModel.voiceLength = 0
        dataArray?.append(voiceViewModel)
        let height: CGFloat = 70.0
        RowHeightArray.append(height)
        reloadData()
        // viewModel.id =  String.init(format: "%d", Date().timeIntervalSince1970 + TimeInterval((arc4random() % 1001) + 10000))
        //        reloadRows(at: [IndexPath.init(row: dataArray!.count - 1, section: 0)], with: .none)
        scrollsToBottomAnimated()
        
    }
    
    
    func updateOneCellData() {
        let cellViewModel = dataArray?.last
        if cellViewModel?.msgType == .voiceMsg {
            dataArray?.removeLast()
            RowHeightArray.removeLast()
        }
         let voiceViewModel =  LSChatCellViewModel(msgType: .voiceMsg, isFromSelf: true)
         voiceViewModel.voiceLength = voiceMsgSecondLength
         voiceViewModel.id = self.voiceViewModelId
         dataArray?.append(voiceViewModel)
        let height: CGFloat = 70.0
        RowHeightArray.append(height)
         reloadData()
    }
    
    func deleteOneCellData() {
        let cellViewModel = dataArray?.last
        if cellViewModel?.msgType == .voiceMsg {
            dataArray?.removeLast()
            RowHeightArray.removeLast()
        }
        reloadData()
    }
}
