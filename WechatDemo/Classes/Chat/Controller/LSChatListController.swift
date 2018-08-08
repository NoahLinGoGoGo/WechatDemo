//
//  LSChatListController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import Alamofire

class LSChatListController: LSBaseViewController {
    
    
    //MARK:- Property
    let viewModel = LSChatListViewModel()
    
    
    //MARK:- LIfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()

    }
    
    
    
    //MARK:- Function    
    override func initUI() {
        title = "微信"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "addadd")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showChatListMenu))
        
        let tableView = LSChatListTableView(viewModel: viewModel)
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        showSearchController = true
        tableView.tableHeaderView = bar
    }
    
    
    func bindData()  {
        
        
        viewModel.loadDataAction?.events.observe({ (event) in
            
            self.updateTabbarItemBadgeNumber(self.viewModel.totalUnReadCount)
        })
        
        viewModel.chatListCellClickSignal.observeValues { (model) in
            
            let chatVC = LSChatController(viewModel: model)
            self.navigationController?.pushViewController(chatVC, animated: true)
            if let model = model {
                self.viewModel.totalUnReadCount -= model.unReadCout
                self.updateTabbarItemBadgeNumber(self.viewModel.totalUnReadCount)
            }
        }
    }
    
    
    func updateTabbarItemBadgeNumber(_ count : Int)   {
        
        UIApplication.shared.applicationIconBadgeNumber = count
        tabBarController?.tabBar.items![0].badgeValue = String(format: "%d", count)
        if count == 0 {
            tabBarController?.tabBar.items![0].badgeValue = nil
        }
        
    }
    
    
    
}
