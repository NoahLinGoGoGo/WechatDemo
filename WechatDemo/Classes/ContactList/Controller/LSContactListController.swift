//
//  LSContactListController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSContactListController: LSBaseViewController,UITableViewDataSource,UITableViewDelegate {

    let tableView = UITableView()
    let viewModel = LSContactListViewModel()
    var firstLetterArray: Array<Any> = Array()
    var sortedModelArr: Array<Any> = Array()
    
    //MARK:- Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()

        bindData()
    }
    
    
    //MARK:- Function
    override func initUI() {
        title = "通讯录"
        showSearchController = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "addadd")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showChatListMenu))
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionIndexColor = RGB51
        tableView.tableHeaderView = bar
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        showSearchController = true
    }
    
    
    func bindData()  {
        
//        self.indexArray = [BMChineseSort IndexWithArray:array Key:@"name"];
//        self.letterResultArr = [BMChineseSort sortObjectArray:array Key:@"name"];
        

        viewModel.loadServeData()
        
        viewModel.loadDataAction?.events.observe({ (event) in
            
            if 0 < self.firstLetterArray.count  && 0 < self.sortedModelArr.count {
                return
            }
            
            BMChineseSort.sortAndGroup(self.viewModel.dataArray, key: "name", finish: { (isSuccess, unGroupArr, sectionTitleArr, sortedObjArr) in
                if isSuccess {
                    self.firstLetterArray = sectionTitleArr as! Array<Any>
                    self.sortedModelArr = sortedObjArr as! Array<Any>
                     self.tableView.reloadData()
//                    print("unGroupArr\(unGroupArr)")
//                    print("sectionTitleArr\(sectionTitleArr)")
//                    print("sortedObjArr\(sortedObjArr)")
//                    for (index,element) in self.firstLetterArray.enumerated() {
//                        print(index,element)
//
//                    }
//                    for (index,element) in self.sortedModelArr.enumerated() {
//                        let obj = element as? Array<LSContactListCellViewModel>
//                        for (inde,elemen) in (obj?.enumerated())! {
//                            print(index,inde,elemen.name)
//
//                        }
//                    }
               
                }
            })

        })
        
    }

    
    //MARK:- UITableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetterArray.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr: Array<Any> = sortedModelArr[section] as! Array
        return arr.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LSContactListCell"
        var cell: LSContactListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? LSContactListCell
        if cell == nil {
            cell = LSContactListCell.init(style: .default, reuseIdentifier: identifier)
        }
        let arr: Array<Any> = sortedModelArr[indexPath.section] as! Array
        cell?.viewModel = arr[indexPath.row] as? LSContactListCellViewModel
        return cell!
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLetterArray as? [String]
    }
    
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firstLetterArray[section] as? String
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}
