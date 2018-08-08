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
    
    
    
    init(viewModel: LSChatListViewModel) {
        super.init(frame: CGRect(), style: .plain)
        self.viewModel = viewModel
        bindData()
       initTableView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTableView() {
        dataSource = self
        delegate = self
        separatorStyle = .none
    }
    
    
    func bindData()  {

        viewModel?.loadDataAction?.events.observe({ (event) in
            self.reloadData()
        })
        
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
            print(model?.name ?? "model.name")
            self.viewModel?.observerGesture.send(value: model)
        })

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0;
    }
    
}
