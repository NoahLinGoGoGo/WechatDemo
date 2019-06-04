//
//  LSContactListCell.swift
//  WechatDemo
//
//  Created by HSDM10 on 2018/8/22.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSContactListCell: UITableViewCell {

    var iconImageView = UIImageView()
    var nameLabel = UILabel()
    var viewModel: LSContactListCellViewModel? {
        didSet{
            iconImageView.image = UIImage(named:(viewModel?.icon)!)
            nameLabel.text = viewModel?.name
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addsubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addsubViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        
        nameLabel.textColor = RGB51
        nameLabel.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.top.equalTo(contentView.snp.top).offset(7.5)
            make.left.equalTo(contentView.snp.left).offset(20)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.left.equalTo(iconImageView.snp.right).offset(15)
        }
    }
}
