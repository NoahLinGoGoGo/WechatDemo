//
//  LSTopMiniProgramView.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/31.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSTopMiniProgramView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var viewModel: LSChatListViewModel?
    var collectionView: UICollectionView!
    var dataArray: Array<LSChatListCellViewModel> = []
   
    let margin: CGFloat = 20
    let identifier = "LSTopMiniProgramCell"
    let sectionHeader = "UICollectionElementKindSectionHeader"
    let sectionHeaderIdentifier = "HeaderView"
    
    //MARK:- Lazy
    lazy var bottomLabel: UILabel = {
        var bottomLabel = UILabel()
        bottomLabel.font = UIFont.systemFont(ofSize: 12.0)
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = bgColor
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.numberOfLines = 0
        bottomLabel.text = "已经到底了😀😀"
        return bottomLabel
    }()
    
    init(viewModel: LSChatListViewModel?) {
        super.init(frame: CGRect())
        self.viewModel = viewModel
        
        initCollectionView()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initCollectionView() {
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60.0, height: 85.0)
        //设置竖直滚动放向(默认是竖直方向)
        layout.scrollDirection = .horizontal
        //设置cell与cell之间的列距
        layout.minimumInteritemSpacing = margin * 1.5
        //设置cell与cell之间的行距
        layout.minimumLineSpacing = margin * 1.5
//        layout.headerReferenceSize = CGSize(width: 300, height: 30)
        
        let collectionViewH: CGFloat = 120.0
         collectionView = UICollectionView(frame: CGRect(x: 0 , y: (miniProgramDefaultH - collectionViewH) * 0.5, width: kScreenW - margin, height: collectionViewH), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LSTopMiniProgramCell.self, forCellWithReuseIdentifier: identifier)
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: sectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    
        
        
        let titleLabel = UILabel(frame: CGRect(x: margin, y: 0, width: 300, height: 30))
        titleLabel.text = "最近使用>"
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.textColor = bgColor
        collectionView.addSubview(titleLabel)

    }
    
    func bindData()  {
    
        viewModel?.chatListScrolltoTopSignal.observeValues { (offsetY, isShow) in
//            print("viewModel.chatListScrolltoTopSignal.observeValues\(offsetY)")
            if self.collectionView.superview == nil && offsetY != -Height_NavBarAndStatusBar{
                self.addSubview(self.collectionView)
                self.backgroundColor = RGB(r: 69, g: 69, b: 69)
            }
            
            var newframe = self.frame
            if offsetY < 0 && isShow {
                newframe.size.height = -offsetY + miniProgramDefaultH
                self.frame = newframe
                print("newframe.size.height\(newframe.size.height)")
                self.collectionView.center.y = newframe.size.height * 0.5
            }
            
            if offsetY == -Height_NavBarAndStatusBar && !isShow {
                newframe.size.height = miniProgramDefaultH
                self.frame = newframe
            }
            
            
            if self.frame.size.height >= kScreenH * 0.75 {
                self.bottomLabel.frame = CGRect(x: 0, y: self.frame.size.height - 50, width: kScreenW, height: 30)
                self.addSubview(self.bottomLabel)
            } else {
                self.bottomLabel.removeFromSuperview()
            }
            
        }
        
        viewModel?.miniProgramDataAction?.events.observeValues({ (signal) in
//            print(signal.event.value)
            if signal.event.value != nil {
                self.dataArray = signal.event.value!
                self.collectionView.reloadData()
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let defaultCollectionHeight = CGFloat(150.0)
//        let topY = ( frame.size.height - defaultCollectionHeight ) * 0.5
//        collectionView.frame = CGRect(x: 0, y: topY, width: kScreenH, height: defaultCollectionHeight)
//        collectionView.center = self.center
        
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LSTopMiniProgramCell? = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LSTopMiniProgramCell
        let viewModel = dataArray[indexPath.row]
        cell?.imageView.image = UIImage(named: viewModel.icon)
        cell?.titleLabel.text = viewModel.name
        return cell!
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == sectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: sectionHeader, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath)
//            let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
//            titleLabel.text = "最近使用>"
//            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
//            titleLabel.textColor = bgColor
//            headerView.addSubview(titleLabel)
//            return headerView
//        } else {
//            return UICollectionReusableView()
//        }
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(margin, margin, 0, 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewModel = dataArray[indexPath.row]
//        viewModel.chatListCellClickSignal.observeValues({ (model) in
//            if  model != nil  {
//                print(model?.name ?? "model = null")
                self.viewModel?.observerGesture.send(value: viewModel)
//            }
//
//        })
    }
}
