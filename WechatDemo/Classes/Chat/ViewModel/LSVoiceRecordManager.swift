//
//  LSVoiceRecordManager.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/7/4.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import AVFoundation

class LSVoiceRecordManager: NSObject {
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    
    //判断是否允许访问麦克风
    func AudioSessionPermissionIsOpen() -> Bool{
        
        let session = AVAudioSession.sharedInstance()
        var allow = false
        session.requestRecordPermission { (allowed) in
            if !allowed{
                let alertView = UIAlertView(title: "无法访问您的麦克风" , message: "请到设置 -> 隐私 -> 麦克风 ,打开访问权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "好的")
                alertView.show()
                allow = false
                
            }else{
                allow = true
                
            }
            
        }
        return allow
    }
    
    
    //开始录音
    func beginRecord(path: String) {
        let path = file_path?.appending("/\(path).wav")
        print("开始录音\(path!)")
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord(path: String) {
        let path = file_path?.appending("/\(path).wav")
        print("结束录音\(path!)")
        if let recorder = self.recorder {
            if recorder.isRecording {
//                print("正在录音，马上结束它，文件保存到了：\(path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    //播放
    func play(path: String) {
        let path = file_path?.appending("/\(path).wav")
        print("播放录音\(path!)")
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            print("录音长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    //播放本地录音文件
    func playLocal(path: String) {
//        print("播放录音\(path)")
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            print("录音长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    
    // 正在播放
    func isPlaying() -> Bool {
        if player != nil {
            return player!.isPlaying
        } else {
            return false
        }
        
    }
    
}
