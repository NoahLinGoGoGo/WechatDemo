//
//  LSBaseViewController.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/27.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSBaseViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    //MARK:- Property
    var showSearchController: Bool? {
        didSet {
            if showSearchController! == true {
                setupSearchController()
            }
        }
    }
    
    var bar: UISearchBar?
    
    fileprivate var searchController: UISearchController = UISearchController.init(searchResultsController: LSSearchResultViewController())
    

    //MARK:- LIfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }
    
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        if searchController.isActive{
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    
     func setupSearchController() {
        searchController.delegate  = self
        searchController.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        bar = searchController.searchBar
        bar?.placeholder = "搜索"
        bar?.setValue("取消", forKey: "_cancelButtonText")
        bar?.contentMode = .center
        bar?.barStyle = .default
        bar?.isTranslucent = true
        bar?.barTintColor = bgColor
        bar?.tintColor =  RGB(r: 26,g: 178,b: 10)
        let view = bar?.subviews[0].subviews.first
        view?.layer.borderColor = bgColor.cgColor
        view?.layer.borderWidth = 1
        bar?.layer.borderColor = UIColor.red.cgColor
        bar?.showsBookmarkButton = true
        bar?.setImage(UIImage.init(named: "VoiceSearchStartBtn"), for: .bookmark, state: .normal)
        bar?.delegate = self
        var  rect = bar?.frame
        rect?.size.height = 44
        bar?.frame = rect!
        bar?.delegate = self
        if #available(iOS 11.0, *) {
            bar?.setPositionAdjustment(UIOffsetMake(kScreenW * 0.4, 0), for: .search)
        }
        
        
        //        if #available(iOS 9.0, *) {
        //            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchbar?.self]).title = "title"
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
    }
    

    func initUI() {
        
    }
    
    
    //MARK: - UISearchController & UISearchBar
    //    func willPresentSearchController(_searchController:UISearchController) {
    //
    //        tabBarController?.tabBar.isHidden=true
    //
    //    }
    
    //    func willDismissSearchController(_searchController:UISearchController) {
    //
    //        tabBarController?.tabBar.isHidden=false
    //
    //    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if #available(iOS 11.0, *) {
            searchBar.setPositionAdjustment(UIOffsetMake(0, 0), for: .search)
        }
        
        return true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if #available(iOS 11.0, *) {
            searchBar.setPositionAdjustment(UIOffsetMake(kScreenW * 0.4, 0), for: .search)
        }
    }
    
    
    
    //    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    //
    //        viewControllerToPresent.tabBarController?.tabBar.isHidden = true
    //
    //        super.present(viewControllerToPresent, animated: flag, completion: completion)
    //    }
    
    
    
     @objc public func showChatListMenu(sender: UIBarButtonItem) {
        
        //配置零：内容配置
        let menuArray = [KxMenuItem.init("发起群聊", image: UIImage(named: "setup_ground"), target: self, action: Selector(("respondOfMenu:"))),
                         KxMenuItem.init("添加朋友", image: UIImage(named: "setup_ground"), target: self, action: Selector(("respondOfMenu:"))),
                         KxMenuItem.init("扫一扫", image: UIImage(named: "setup_ground"), target: self, action: Selector(("respondOfMenu:"))),
                         KxMenuItem.init("收付款", image: UIImage(named: "setup_ground"), target: self, action: Selector(("respondOfMenu:")))]
        
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
        KxMenu.show(in: self.view, from: frame, menuItems: menuArray , withOptions: options)
    }

}
