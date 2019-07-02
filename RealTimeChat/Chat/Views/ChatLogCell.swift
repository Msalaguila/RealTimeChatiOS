//
//  ChatLogCell.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 02/07/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import LBTATools

class ChatLogCell: UICollectionViewCell {
    
    var messageText: UILabel = {
        var lb = UILabel()
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        contentView.addSubviewForAutolayout(messageText)
        
        messageText.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
    }
}
