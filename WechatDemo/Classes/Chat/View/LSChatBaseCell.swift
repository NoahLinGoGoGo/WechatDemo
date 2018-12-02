//
//  LSChatBaseCell.swift
//  WechatDemo
//
//  Created by 周结论 on 2018/6/28.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSChatBaseCell: UITableViewCell {
    
    var iconImageView = UIImageView()
    var bgImageView = UIImageView()
    var viewModel: LSChatViewModel?
    var cellViewModel: LSChatCellViewModel?
    var bgClearBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addsubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addsubViews() {
        
        backgroundColor = bgColor
        contentView.backgroundColor = bgColor
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(iconImageView)
        contentView.insertSubview(bgClearBtn, aboveSubview: bgImageView)
        bgClearBtn.backgroundColor = UIColor.clear
        bgClearBtn.addTarget(self, action: #selector(self.bgClearBtnClick(_:)), for: .touchUpInside)
    }
    
    func configure(indexpath: IndexPath,  viewModel: LSChatViewModel, array:Array<LSChatCellViewModel>) {
        selectionStyle = .none
//        tag = 100 + indexpath.row
        self.viewModel = viewModel
        cellViewModel = array[indexpath.row]
       
        var bgImage = UIImage()
        if cellViewModel!.isFromSelf {
            bgImage = UIImage(named: "SenderBlueBG")!
            iconImageView.image = UIImage(named:"myIcon.jpg")
        } else {
            bgImage = UIImage(named: "ReceiverShiteBG")!
             iconImageView.image = UIImage(named:(viewModel.userViewModel?.icon)!)
        }
        
        let newBgImage = bgImage.stretchableImage(withLeftCapWidth: Int(bgImage.size.width * 0.5), topCapHeight: Int(bgImage.size.height * 0.5))
        bgImageView.image = newBgImage
        

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubViewFrame()
    }

     func updateSubViewFrame()  {
    
        if cellViewModel!.isFromSelf {
            
            iconImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentView.snp.top).offset(10)
                make.right.equalTo(contentView.snp.right).offset(-10)
                make.width.equalTo(40)
                make.height.equalTo(40)
            }
            
        } else {
            
            iconImageView.snp.makeConstraints { (make) in
                make.top.equalTo(contentView.snp.top).offset(10)
                make.right.equalTo(contentView.snp.left).offset(50)
                make.width.equalTo(40)
                make.height.equalTo(40)
            }

        }
    
    }
    
    
    @objc func bgClearBtnClick(_ button: UIButton){
        viewModel?.observerBottomBarBgClearCoverBtnClick.send(value: cellViewModel!)
    }
    
    
}
