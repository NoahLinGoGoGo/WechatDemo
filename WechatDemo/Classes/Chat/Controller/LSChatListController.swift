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
        showSearchController = true
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "addadd")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showChatListMenu))
        
        let tableView = LSChatListTableView(viewModel: viewModel, bar: bar)
//        tableView.frame = view.bounds
        tableView.frame = CGRect(x: 0, y: Height_NavBarAndStatusBar, width: kScreenW, height: kScreenH - Height_TabBar - Height_NavBarAndStatusBar)
        view.addSubview(tableView)
        
        // viewModel 中处理topMiniProgramView数据与交互
        let topMiniProgramView = LSTopMiniProgramView(viewModel: viewModel)
        topMiniProgramView.frame = CGRect(x: 0, y: Height_NavBarAndStatusBar, width: kScreenW, height: miniProgramDefaultH)
        view.insertSubview(topMiniProgramView, belowSubview: tableView)
        
        
    }
    
    
    func bindData()  {
        
        viewModel.loadDataAction?.events.observe({ (event) in
            
            self.updateTabbarItemBadgeNumber(self.viewModel.totalUnReadCount)
        })
        
        viewModel.chatListCellClickSignal.observeValues { (model) in
            if model != nil &&  (self.navigationController?.childViewControllers.count)! > 0 {
                
                for (_, element) in (self.navigationController?.childViewControllers.enumerated())! {
                    if element is LSChatController {
                        return
                    }
                }
                
                let chatVC = LSChatController(viewModel: model)
                self.navigationController?.pushViewController(chatVC, animated: true)
                self.viewModel.totalUnReadCount -= model!.unReadCout
                self.updateTabbarItemBadgeNumber(self.viewModel.totalUnReadCount)
                
            }
        }
        
        
    }
    
    
    func updateTabbarItemBadgeNumber(_ count : Int)   {
        
        // 网络不好的时候会计算出负数和计算不准确
        UIApplication.shared.applicationIconBadgeNumber = count
        tabBarController?.tabBar.items![0].badgeValue = String(format: "%d", count)
        if count == 0 {
            tabBarController?.tabBar.items![0].badgeValue = nil
        }
        
    }
    
    
    @objc public func showChatListMenu(sender: UIBarButtonItem) {
        
        //配置零：内容配置
        let menuArray = [KxMenuItem.init("发起群聊", image: UIImage(named: "setup_ground"), target: self, action: #selector(LSChatListController.respondOfMenu(_:))),
                         KxMenuItem.init("添加朋友", image: UIImage(named: "setup_ground"), target: self, action: #selector(LSChatListController.respondOfMenu(_:))),
                         KxMenuItem.init("扫一扫", image: UIImage(named: "setup_ground"), target: self, action: #selector(LSChatListController.respondOfMenu(_:))),
                         KxMenuItem.init("收付款", image: UIImage(named: "setup_ground"), target: self, action: #selector(LSChatListController.respondOfMenu(_:)))]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(
            arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: false,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 255, G: 255, B: 255),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 0, G: 0, B: 0)  //菜单的底色
        )
        
        let frame = CGRect(x: kScreenW - 30, y: 70, width: 0, height: 0)
        
        //菜单展示
        KxMenu.show(in: self.view, from: frame, menuItems: menuArray as Any as? [Any] , withOptions: options)
    }
    
    @objc func respondOfMenu(_ sender: AnyClass) {
        
    }
    
}
