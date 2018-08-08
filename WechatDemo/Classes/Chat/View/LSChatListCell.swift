//
//  LSChatListCell.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LSChatListCell: UITableViewCell {
    
    private var iconImageView = UIImageView()
    private var nameLabel = UILabel()
    private var timeLabel =  UILabel()
    private var messageLabel =  UILabel()
    private var unReadLabel =  UILabel()
    private var lineLabel = UILabel()
   
    
    var viewModel: LSChatListCellViewModel?{
        didSet {
            iconImageView.image = UIImage(named: viewModel!.icon)
            nameLabel.text = viewModel!.name
            timeLabel.text = viewModel!.time
            messageLabel.text = viewModel?.message
            
            if viewModel?.unReadCout == 0 {
                unReadLabel.removeFromSuperview()
                
            } else if viewModel!.unReadCout >= 100 {
                addUnReadLabel("99+")
            } else {
                addUnReadLabel(String.init(format: "%d", viewModel!.unReadCout))
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addGestures()
        addsubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func addGestures()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellClick))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellClick))
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
    }
    
    
    func addsubViews() {
        
        iconImageView.layer.cornerRadius = 5.0
        iconImageView.layer.masksToBounds = true
        
        nameLabel.textColor = RGB(r: 51, g: 51, b: 51)
        nameLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        messageLabel.textColor = RGB(r: 148, g: 148, b: 148)
        messageLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        timeLabel.textColor = RGB(r: 148, g: 148, b: 148)
        timeLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        unReadLabel.backgroundColor = RGB(r: 251, g: 32, b: 37)
        unReadLabel.textColor = UIColor.white
        unReadLabel.font = UIFont.systemFont(ofSize: 12.0)
        unReadLabel.textAlignment = .center
        unReadLabel.layer.cornerRadius = 9
        unReadLabel.layer.masksToBounds = true
        
        lineLabel.backgroundColor = RGB(r: 228, g: 228, b: 228)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lineLabel)
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top).offset(5)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView.snp.bottom).offset(-5)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }
        
        
        lineLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0.3)
            
        }

    }
    
    
    
    @objc func cellClick(gesture: UIGestureRecognizer) {
            removeGestureRecognizer(gesture)
            switch gesture.state {
            case .ended:
                if gesture is  UITapGestureRecognizer {
                    backgroundColor = bgColor
                    
                }

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    
                    self.viewModel?.observerGesture.send(value: self.viewModel)
                    self.backgroundColor = RGB(r: 255, g: 255, b: 255)
                    self.viewModel?.unReadCout = 0
                    self.unReadLabel.removeFromSuperview()
                    self.addGestureRecognizer(gesture)
                }
                
            default:
                backgroundColor = bgColor
            }
        
    }

    
    
    func addUnReadLabel(_ text: String)  {
        unReadLabel.text = text
        contentView.addSubview(unReadLabel)
        let unReadTextW  = text.boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: Double(20)),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.0)] ,context: nil).size.width
        
        var unReadLabelW = unReadTextW + 10.0
        
        if unReadLabelW  < 18.0 {
            unReadLabelW = 18.0
        }
        unReadLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.right)
            make.centerY.equalTo(iconImageView.snp.top)
            make.height.equalTo(18)
            make.width.equalTo(unReadLabelW)
        }
    }
    
    
}
