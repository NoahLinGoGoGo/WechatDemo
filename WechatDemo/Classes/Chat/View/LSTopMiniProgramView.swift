//
//  LSTopMiniProgramView.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/31.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSTopMiniProgramView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewModel: LSChatListViewModel?

    var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    var bottomLabel = UILabel()
    let identifier = "LSTopMiniProgramCell"
    
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
        layout.itemSize = CGSize(width: 80.0, height: 110.0)
        //设置竖直滚动放向(默认是竖直方向)
        layout.scrollDirection = .vertical
        //设置cell与cell之间的列距
        layout.minimumInteritemSpacing = 1
        //设置cell与cell之间的行距
//        layout.minimumLineSpacing = 1
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LSTopMiniProgramCell.self, forCellWithReuseIdentifier: identifier)
        
        
        
        bottomLabel.text = "已经到底了——"
//        bottomLabel.isHidden = true
        addSubview(bottomLabel)
    }
    
    func bindData()  {
        viewModel?.chatListScrolltoTopSignal.observeValues { (offsetY) in
//            print("viewModel.chatListScrolltoTopSignal.observeValues\(offsetY)")
            if self.collectionView.superview == nil {
                self.addSubview(self.collectionView)
                self.backgroundColor = RGB(r: 69, g: 69, b: 69)
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let defaultCollectionHeight = CGFloat(150.0)
        let topY = ( frame.size.height - defaultCollectionHeight ) * 0.5
        collectionView.frame = CGRect(x: 0, y: topY, width: kScreenH, height: defaultCollectionHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LSTopMiniProgramCell? = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LSTopMiniProgramCell

//        cell?.configure(indexpath: indexPath, viewModel: viewModel!, array: dataArray!)
        return cell!
    }
}
