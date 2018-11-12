//
//  LSChatListTableView.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/27.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSChatListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Property
    var viewModel: LSChatListViewModel?
    let blankMaskView = UIView()
    var bar: UISearchBar?
    var miniProgramViewIsFullShow = false
    var tableViewOriginY: CGFloat? = nil
    var tableViewOriginH: CGFloat? = nil
    var tableViewScrollY: CGFloat = -Height_NavBarAndStatusBar
    var voiceRecordManager = LSVoiceRecordManager()
    
    init(viewModel: LSChatListViewModel, bar: UISearchBar?) {
        super.init(frame: CGRect(), style: .plain)
        self.viewModel = viewModel
        self.bar = bar
        viewModel.loadServerData()
        bindData()
        initTableView()
        //        addTopHeaderView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initTableView()  {
        dataSource = self
        delegate = self
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        backgroundColor = UIColor.clear
        
        //        let pan = UIPanGestureRecognizer(target: self, action: #selector(panTableView))
        //        addGestureRecognizer(pan)
    }
    
    
    func bindData()  {
        
        viewModel?.loadDataAction?.events.observe({ (event) in
            self.updateMainView()
        })
        
        viewModel?.chatListCellClickSignal.observeValues { (model) in
            if model != nil {
                var rect = self.frame
                rect.origin.y = self.tableViewOriginY!
                rect.size.height = self.tableViewOriginH!
                self.frame = rect
                self.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                self.miniProgramViewIsFullShow = false
            }
        }
        
    }
    
    
    func updateMainView() {
        if let count = viewModel?.dataArray.count {
            if 0 >= count {
                
                blankMaskView.frame = self.bounds
                blankMaskView.backgroundColor = RGB(r: 244, g: 244, b: 244)
                
                let refreshBtn = UIButton(type: .custom);
                refreshBtn.setTitle("点击刷新", for: .normal)
                refreshBtn.setTitleColor(RGB(r: 214, g: 214, b: 214), for: .normal)
                refreshBtn.addTarget(self, action: #selector(self.refreshBtnClick(_:)), for: .touchUpInside)
                refreshBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
                refreshBtn.center = self.center
                refreshBtn.layer.cornerRadius = 5.0
                refreshBtn.layer.masksToBounds = true
                refreshBtn.layer.borderColor = RGB(r: 214, g: 214, b: 214).cgColor
                refreshBtn.layer.borderWidth = 1
                blankMaskView.addSubview(refreshBtn)
                addSubview(blankMaskView)
            } else {
                self.reloadData()
            }
        }
    }
    
    
    @objc func refreshBtnClick (_ button: UIButton) {
        button.removeFromSuperview()
        blankMaskView.removeFromSuperview()
        viewModel?.loadServerData()
        self.reloadData()
    }
    
    
    //    @objc func panTableView(gesture: UIGestureRecognizer) {
    //        switch gesture.state {
    //        case .ended:
    //            print("end")
    //        default:
    //            print("default")
    //        }
    //
    //    }
    
    //MARK:- UITableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.dataArray.count {
            return count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if 0 == indexPath.row {
            let identifier = "UITableViewCell"
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            }
            if let bar = bar {
                bar.frame = (cell?.contentView.bounds)!
                cell?.contentView.addSubview(bar)
            }
            return cell!
        } else {
            let identifier = "LSChatListCell"
            var cell: LSChatListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSChatListCell
            if cell == nil {
                cell = LSChatListCell.init(style: .default, reuseIdentifier: identifier)
            }
            
            cell?.viewModel = viewModel?.dataArray[indexPath.row - 1]
            cell?.viewModel?.chatListCellClickSignal.observeValues({ (model) in
                if  model != nil  {
                    print(model?.name ?? "model = null")
                    self.viewModel?.observerGesture.send(value: model)
                }
                
            })
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.row {
            return 54.0
        }
        return 65.0;
    }
    
    
    //MARK:- UITableView DataSource & Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self {
            return
        }
        //print("scrollViewDidScrollscrollViewDidScrollscrollViewDidScroll")
        // rac传递偏移量给viewmodel
        let offsetY = scrollView.contentOffset.y
        if tableViewOriginY == nil {
            tableViewOriginY = self.frame.origin.y
        }
        if tableViewOriginH == nil {
            tableViewOriginH = self.frame.size.height
        }
        
//        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
//        print("tableViewOriginY: \(tableViewOriginY ?? -1)")
//        print("self.frame.origin.y: \(self.frame.origin.y)")
        
        
        // 动画 + 加载数组
        if offsetY < -Height_NavBarAndStatusBar && offsetY > -miniProgramDefaultH * 0.5 {
            if self.frame.origin.y < miniProgramDefaultH {
                viewModel?.miniProgramDataAction?.apply().start()
            }
            viewModel?.observerMiniProgram.send(value: (offsetY,false))

            // 手指向下移动的时候，用户是否大力拖拽，只有显示的数据是第一行的时候才让显示miniProgramView
            // 去掉bounds效果(不让弹回)   +   播放音效
        } else if (offsetY < -miniProgramDefaultH * 0.5 && !miniProgramViewIsFullShow && tableViewScrollY <= -Height_NavBarAndStatusBar  && tableViewScrollY >= -Height_NavBarAndStatusBar - 30){
            UIView.animate(withDuration: 0.2, animations: {
                var rect = self.frame
                rect.origin.y += miniProgramDefaultH + Height_NavBarAndStatusBar
                rect.size.height -= miniProgramDefaultH
                self.frame = rect
                scrollView.bounces = false
            }) { (flag) in
                let path = Bundle.main.path(forResource: "miniprogram_open", ofType: "wav")
                if let path = path {
                    self.voiceRecordManager.playLocal(path: path)
                }
                
                scrollView.bounces = true
            }
            miniProgramViewIsFullShow = true
            
            viewModel?.observerMiniProgram.send(value: (offsetY,scrollView.bounces))
            
            /*
             手指向上移动的时候，判断用户是否大力拖拽，这时候显示的数据应该是是第一行，隐藏miniProgramView   self.frame.origin.y <= miniProgramDefaultH * 0.9， 因为微信这里没有处理，所以暂时没有做
             */
        } else if (offsetY >= 1 && miniProgramViewIsFullShow){
            scrollView.bounces = true
            UIView.animate(withDuration: 0.2) {
                var rect = self.frame
                rect.origin.y = self.tableViewOriginY!
                rect.size.height = self.tableViewOriginH!
                self.frame = rect
                self.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            
            miniProgramViewIsFullShow = false
           
            viewModel?.observerMiniProgram.send(value: (offsetY,false))
        } else {
            // - Height_NavBarAndStatusBar 到 0
            
            viewModel?.observerMiniProgram.send(value: (offsetY,miniProgramViewIsFullShow))
        }
        
//
//                    if miniProgramViewIsFullShow && tableViewScrollY >= -miniProgramDefaultH{
//                        scrollView.bounces = false
//                    } else {
//                        scrollView.bounces = true
//                    }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //    print("scrollViewDidEndDeceleratingscrollViewDidEndDeceleratingscrollViewDidEndDecelerating")
        //        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        //        print("tableViewOriginY: \(tableViewOriginY ?? -1)")
        //        print("self.frame.origin.y: \(self.frame.origin.y)")
        tableViewScrollY = scrollView.contentOffset.y
    }
    
    
}
