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
        
        let toolBarH: CGFloat = 50.0
       
        let toolBar = LSChatBottomBar(viewModel: viewModel)
        toolBar.frame = CGRect(x: 0, y: kScreenH - toolBarH, width: kScreenW, height: toolBarH)
        view.addSubview(toolBar)
        
         let tableView = LSChatTableView(viewModel: viewModel)
         tableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - toolBarH)
         view.addSubview(tableView)
        
    }
    
    func bindData() {
        viewModel.bgClearBtnClickSignal.observeValues({ (cellViewModel) in
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
