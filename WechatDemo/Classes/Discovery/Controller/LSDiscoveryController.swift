//
//  LSDiscoveryController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSDiscoveryController: UITableViewController {

    var viewModel = LSDiscoveryViewModel()
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        bindData()
    }

    func initUI() {
        title = "发现"
        
        tableView.sectionHeaderHeight = 20.0
        tableView.sectionFooterHeight = 0.0;
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    func bindData()  {
        
        viewModel.loadServerData()
        viewModel.loadDataAction?.events.observe({ (event) in
            print(self.viewModel.dataArray)
            self.tableView.reloadData()
        })
        
    }
   

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr: Array<(String, String)> = viewModel.dataArray[section]
        return arr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "UITableViewCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        let arr: Array<(String, String)> = viewModel.dataArray[indexPath.section]
        cell?.imageView?.image = UIImage(named: arr[indexPath.row].0)
        cell?.textLabel?.text = arr[indexPath.row].1
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight;
    }

}
