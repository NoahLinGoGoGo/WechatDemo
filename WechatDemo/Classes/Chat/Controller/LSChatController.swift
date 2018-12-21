//
//  LSChatController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/13.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class LSChatController: UIViewController {
    
    //MARK:- Property
    let viewModel = LSChatViewModel()
    var bottomBarH: CGFloat = 50.0
    var bottomBar =  LSChatBottomBar.init(viewModel: nil)
    var tableView =  LSChatTableView(viewModel: nil)
    
    
    init(viewModel: LSChatListCellViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.userViewModel = viewModel
        title = viewModel?.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindData()
        
    }
    
    
    
    func configureUI() {
        tableView = LSChatTableView(viewModel: viewModel)
        tableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - bottomBarH)
        view.addSubview(tableView)
        
        bottomBar = LSChatBottomBar(viewModel: viewModel)
        bottomBar.frame = CGRect(x: 0, y: kScreenH - bottomBarH, width: kScreenW, height: bottomBarH)
        view.addSubview(bottomBar)
        
    }
    
    func bindData() {
        // button , textfield 可以直接动态绑定，不用通过Signal ？
        viewModel.bottomBarBgClearCoverBtnClickSignal.observeValues({ (cellViewModel) in
            
            if cellViewModel.msgType == .imageMsg {
                
                // 微信此处需要从聊天记录里面读取多张图片
                var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImageURL(cellViewModel.imageUrl)
                photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
                images.append(photo)
                
                let browser = SKPhotoBrowser(photos: images)
                browser.initializePageIndex(0)
                self.present(browser, animated: true, completion: {})
            }
        })
        
        
        viewModel.bottomBarTextViewIsEditingSignal.observeValues { (textViewH) in
            self.bottomBarH = textViewH + 15.0
            if  self.bottomBarH > 50.0{
                self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - self.bottomBarH)
                self.bottomBar.frame = CGRect(x: 0, y: kScreenH - self.bottomBarH, width: kScreenW, height: self.bottomBarH)
                
//                print("contentTextH:\(self.bottomBarH)self.bottomBar.frame:\(self.bottomBar.frame)")
            }
        }
        
        
        viewModel.bottomBarTextViewDidClickSendSignal.observeValues({ (inputText) in
            self.bottomBarH = 50.0
            self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - self.bottomBarH)
            self.bottomBar.frame = CGRect(x: 0, y: kScreenH - self.bottomBarH, width: kScreenW, height: self.bottomBarH)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
