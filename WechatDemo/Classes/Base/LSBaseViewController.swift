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
    
    
    
    
}
