//
//  LSMeController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSMeController: UITableViewController {

    var viewModel = LSMeViewModel()
    
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
        title = "我"
        
        tableView.sectionHeaderHeight = 20.0
        tableView.sectionFooterHeight = 0.0;
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    func bindData()  {
        
        viewModel.loadServeData()
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
        let arr: Array<(String, String, String)> = viewModel.dataArray[section]
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "UITableViewCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            if 0 ==  indexPath.section {
                 cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
            } else {
                 cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            }
           
        }
        let arr: Array<(String, String, String)> = viewModel.dataArray[indexPath.section]
        cell?.imageView?.image = UIImage(named: arr[indexPath.row].0)
        cell?.textLabel?.text = arr[indexPath.row].1
        if 0 == indexPath.section {
            cell?.detailTextLabel?.text = arr[indexPath.row].2
            // 调整imageView大小
            let imageSize = CGSize(width: 60, height: 60)
            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
            let imageRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            cell?.imageView?.image?.draw(in: imageRect)
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            cell?.imageView?.layer.cornerRadius = 5.0
            cell?.imageView?.layer.masksToBounds = true
            UIGraphicsEndImageContext()
        }
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight;
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 ==  indexPath.section {
            return 80.0
        } else {
            return 44.0;
        }
    }

}
