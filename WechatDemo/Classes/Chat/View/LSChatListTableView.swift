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
    let greyView = UIView()
    var bar: UISearchBar?
    var miniProgramViewIsShow = false
    var tableViewOriginY: CGFloat? = nil
    var tableViewOriginH: CGFloat? = nil
    
    init(viewModel: LSChatListViewModel, bar: UISearchBar?) {
        super.init(frame: CGRect(), style: .plain)
        self.viewModel = viewModel
        self.bar = bar
        viewModel.loadServeData()
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
    }
    
    
    func bindData()  {
        
        viewModel?.loadDataAction?.events.observe({ (event) in
            self.updateMainView()
        })
        
        
        
        
    }
    
    
    func updateMainView() {
        if let count = viewModel?.dataArray.count {
            if 0 >= count {
                
                greyView.frame = self.bounds
                greyView.backgroundColor = RGB(r: 244, g: 244, b: 244)
                
                let refreshBtn = UIButton(type: .custom);
                refreshBtn.setTitle("点击只刷新一次", for: .normal)
                refreshBtn.setTitleColor(RGB(r: 214, g: 214, b: 214), for: .normal)
                refreshBtn.addTarget(self, action: #selector(self.refreshBtnClick(_:)), for: .touchUpInside)
                refreshBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
                refreshBtn.center = self.center
                refreshBtn.layer.cornerRadius = 5.0
                refreshBtn.layer.masksToBounds = true
                refreshBtn.layer.borderColor = RGB(r: 214, g: 214, b: 214).cgColor
                refreshBtn.layer.borderWidth = 1
                greyView.addSubview(refreshBtn)
                addSubview(greyView)
            } else {
                self.reloadData()
            }
        }
    }
    
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
            return 44.0
        }
        return 65.0;
    }
    
    
    @objc func refreshBtnClick (_ button: UIButton) {
        button.removeFromSuperview()
        greyView.removeFromSuperview()
        viewModel?.loadServeData()
        self.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
print("scrollViewDidScroll")
        // rac传递偏移量给viewmodel
        let offsetY = scrollView.contentOffset.y
        if tableViewOriginY == nil {
            tableViewOriginY = self.frame.origin.y
        }
        if tableViewOriginH == nil {
            tableViewOriginH = self.frame.size.height
        }

        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        //        print("self.frame.origin.y: \(tableViewOriginY ?? 0)")
        //        print("self.frame.size.height: \(tableViewOriginH ?? 0)")
        
        if offsetY < -64 && offsetY > -miniProgramDefaultH * 0.5{
           
             viewModel?.observerMiniProgram.send(value: offsetY)
            
            // 判断用户是否大力拖拽，只有显示的数据是第一行的时候才让显示miniProgramView
        } else if (offsetY < -miniProgramDefaultH * 0.5 && !miniProgramViewIsShow){

            UIView.animate(withDuration: 0.2) {
                var rect = self.frame
                rect.origin.y = rect.origin.y + miniProgramDefaultH
                rect.size.height = rect.size.height - miniProgramDefaultH
                self.frame = rect
            }
            miniProgramViewIsShow = true
             viewModel?.observerMiniProgram.send(value: offsetY)
            
            // 判断用户是否大力拖拽，显示的数据是第一行
        } else if (offsetY > 50 && miniProgramViewIsShow){
            
            UIView.animate(withDuration: 0.2) {
                var rect = self.frame
                rect.origin.y = self.tableViewOriginY!
                rect.size.height = self.tableViewOriginH!
                self.frame = rect
                self.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            
            miniProgramViewIsShow = false
            viewModel?.observerMiniProgram.send(value: offsetY)
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
}
