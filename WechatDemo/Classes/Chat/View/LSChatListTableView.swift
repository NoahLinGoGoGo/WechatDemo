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
    
    
    init(viewModel: LSChatListViewModel) {
        super.init(frame: CGRect(), style: .plain)
        self.viewModel = viewModel
        viewModel.loadServeData()
        bindData()
        initTableView()
        addTopHeaderView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTopHeaderView()  {
        
    }
    
    func initTableView()  {
        dataSource = self
        delegate = self
        separatorStyle = .none
        showsVerticalScrollIndicator = false
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
            }  else {
            self.reloadData()
            }
        }
    }
    
    //MARK:- UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.dataArray.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "LSChatListCell"
        var cell: LSChatListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSChatListCell
        if cell == nil {
            cell = LSChatListCell.init(style: .default, reuseIdentifier: identifier)
        }
            
        cell?.viewModel = viewModel?.dataArray[indexPath.row]
        cell?.viewModel?.chatListCellClickSignal.observeValues({ (model) in
            if  model != nil  {
                print(model?.name ?? "model.name")
                self.viewModel?.observerGesture.send(value: model)
            }
            
        })

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0;
    }
    
    
    @objc func refreshBtnClick (_ button: UIButton) {
        button.removeFromSuperview()
        greyView.removeFromSuperview()
        viewModel?.loadServeData()
        self.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y\(scrollView.contentOffset.y)")
        print("bounds.origin.y\(bounds.origin.y)")
        print("bounds.size.height\(bounds.size.height)")
        
    }
}
